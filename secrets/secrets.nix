let
  keys = import ../shared-modules/keys.nix;
  inherit (keys) sam nix-lab minecraft;
in {
  "nomad-samba-credentials.age".publicKeys = [sam nix-lab];
  "hcloud-token.age".publicKeys = [sam];
  "caddy-cloudflare-key.age".publicKeys = [sam nix-lab minecraft];
  "ssc-secrets.age".publicKeys = [sam nix-lab];
  "miniflux-admin-credentials.age".publicKeys = [sam nix-lab];
}
