{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.sam.wlrun;

  wlrun = pkgs.writeShellScriptBin "wlrun" ''
    set -eu
    app_id=""
    if [ "''${1:-}" = "-a" ]; then
      app_id=$2
      shift 2
    fi
    if [ $# -lt 1 ]; then
      echo "usage: wlrun [-a app-id] <command...>" >&2
      exit 1
    fi
    [ -n "$app_id" ] || app_id=''${1##*/}

    sock="$XDG_RUNTIME_DIR/wlrun-$app_id-$$"
    fifo=$(${pkgs.coreutils}/bin/mktemp -u)
    ${pkgs.coreutils}/bin/mkfifo "$fifo"

    cleanup() {
      [ -n "''${ws_pid:-}" ] && kill "$ws_pid" 2>/dev/null || true
      rm -f "$sock" "$fifo"
    }
    trap cleanup EXIT INT TERM

    ${pkgs.way-secure}/bin/way-secure \
      --socket-path "$sock" \
      -e dev.samiser.wlrun -a "$app_id" -i "$app_id-$$" \
      -r 3 3> "$fifo" &
    ws_pid=$!

    # readiness: way-secure writes to fd 3 once the context is committed
    read -r _ < "$fifo" || true
    rm -f "$fifo"
    kill -0 "$ws_pid" 2>/dev/null || {
      echo "wlrun: way-secure failed" >&2
      exit 1
    }

    WAYLAND_DISPLAY=''${sock##*/} "$@"
  '';
in
{
  options.sam.wlrun.enable = lib.mkEnableOption "restricted wayland app launcher";

  config = lib.mkIf cfg.enable {
    home.packages = [ wlrun ];
  };
}
