#!/usr/bin/env python3
"""Report closure sizes for every host in the flake, without building anything.

Sizes come from narinfo metadata served over HTTP, so this works for hosts you
have never built locally (including hosts of a different architecture).

Two caches are consulted per path. The private attic cache holds only
host-specific paths: attic's `upstream-cache-key-names` defaults to
["cache.nixos.org-1"], so `attic push` skips anything already signed upstream.
A closure walk therefore has to fall back to cache.nixos.org, and no single
`nix path-info --store ...` invocation can span both.
"""

import argparse
import json
import subprocess
import sys
import urllib.error
import urllib.request
from concurrent.futures import ThreadPoolExecutor
from threading import Lock

DEFAULT_CACHES = ["https://cache.samiser.xyz/main", "https://cache.nixos.org"]

EVAL_APPLY = """
cfgs: builtins.mapAttrs (_: c: {
  path = c.config.system.build.toplevel.outPath;
  system = c.pkgs.stdenv.hostPlatform.system;
}) cfgs
"""


def eval_hosts(flake, output):
    """Return {host: {path, system}} for a flake output, or {} if it has none."""
    proc = subprocess.run(
        ["nix", "eval", "--json", f"{flake}#{output}", "--apply", EVAL_APPLY],
        capture_output=True,
        text=True,
    )
    if proc.returncode != 0:
        print(f"warning: could not evaluate {output}:", file=sys.stderr)
        print(proc.stderr.strip(), file=sys.stderr)
        return {}
    return json.loads(proc.stdout)


class NarinfoStore:
    """Fetches and caches narinfo metadata, falling back across caches."""

    def __init__(self, caches):
        self.caches = caches
        self.entries = {}  # hash -> (nar_size, file_size, [ref hashes]) | None
        self.lock = Lock()

    def get(self, digest):
        with self.lock:
            if digest in self.entries:
                return self.entries[digest]

        entry = None
        for base in self.caches:
            try:
                with urllib.request.urlopen(
                    f"{base}/{digest}.narinfo", timeout=30
                ) as response:
                    entry = parse_narinfo(response.read().decode())
                break
            except urllib.error.HTTPError as err:
                if err.code == 404:
                    continue
                raise

        with self.lock:
            self.entries[digest] = entry
        return entry


def parse_narinfo(body):
    nar_size = file_size = 0
    refs = []
    for line in body.splitlines():
        key, _, value = line.partition(": ")
        if key == "NarSize":
            nar_size = int(value)
        elif key == "FileSize":
            file_size = int(value)
        elif key == "References":
            refs = [ref.split("-", 1)[0] for ref in value.split() if ref]
    return nar_size, file_size, refs


def walk_closure(root, store, pool):
    """Breadth-first walk from a store path. Returns (paths, missing hashes)."""
    digest = root.split("/")[-1].split("-", 1)[0]
    seen, missing, frontier = set(), set(), [digest]
    while frontier:
        batch = [h for h in frontier if h not in seen]
        seen.update(batch)
        frontier = []
        for h, entry in zip(batch, pool.map(store.get, batch)):
            if entry is None:
                missing.add(h)
                continue
            frontier.extend(ref for ref in entry[2] if ref not in seen)
    return seen, missing


def human(size):
    for unit in ["B", "KiB", "MiB", "GiB", "TiB"]:
        if abs(size) < 1024 or unit == "TiB":
            return f"{size:.1f} {unit}"
        size /= 1024


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "flake", nargs="?", default=".", help="flake ref to measure (default: .)"
    )
    parser.add_argument(
        "--cache",
        action="append",
        dest="caches",
        metavar="URL",
        help=f"binary cache to query, in order (default: {' '.join(DEFAULT_CACHES)})",
    )
    parser.add_argument("--json", action="store_true", help="emit JSON instead")
    parser.add_argument(
        "--jobs", type=int, default=32, help="concurrent fetches (default: 32)"
    )
    args = parser.parse_args()

    hosts = {
        **eval_hosts(args.flake, "nixosConfigurations"),
        **eval_hosts(args.flake, "darwinConfigurations"),
    }
    if not hosts:
        sys.exit("error: no host configurations found")

    store = NarinfoStore(args.caches or DEFAULT_CACHES)
    results, everything = [], set()

    with ThreadPoolExecutor(max_workers=args.jobs) as pool:
        for host, info in hosts.items():
            paths, missing = walk_closure(info["path"], store, pool)
            everything |= paths
            results.append(
                {
                    "host": host,
                    "system": info["system"],
                    "path": info["path"],
                    "closureSize": sum(store.entries[h][0] for h in paths - missing),
                    "downloadSize": sum(store.entries[h][1] for h in paths - missing),
                    "paths": len(paths),
                    "uncached": sorted(missing),
                }
            )

    results.sort(key=lambda r: r["closureSize"], reverse=True)

    if args.json:
        print(json.dumps(results, indent=2))
        return

    print(f"{'host':<14}{'system':<15}{'closure':>10}{'download':>11}{'paths':>8}")
    print("-" * 58)
    for r in results:
        print(
            f"{r['host']:<14}{r['system']:<15}"
            f"{human(r['closureSize']):>10}{human(r['downloadSize']):>11}"
            f"{r['paths']:>8}"
        )

    unique = sum(store.entries[h][0] for h in everything if store.entries[h])
    print("-" * 58)
    print(f"{'all hosts':<29}{human(unique):>10}{'':>11}{len(everything):>8}  deduped")

    stragglers = {h for r in results for h in r["uncached"]}
    if stragglers:
        print(
            f"\n{len(stragglers)} path(s) missing from every cache; "
            "sizes above are underestimates.",
            file=sys.stderr,
        )
        for h in sorted(stragglers):
            print(f"  {h}", file=sys.stderr)


if __name__ == "__main__":
    main()
