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
    sandbox=""
    while [ $# -gt 0 ]; do
      case $1 in
        -a) app_id=$2; shift 2 ;;
        -s) sandbox=1; shift ;;
        *) break ;;
      esac
    done
    if [ $# -lt 1 ]; then
      echo "usage: wlrun [-a app-id] [-s] <command...>" >&2
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

    if [ -z "$sandbox" ]; then
      WAYLAND_DISPLAY=''${sock##*/} "$@"
      exit
    fi

    app_home="$HOME/.local/share/wlrun/$app_id"
    mkdir -p "$app_home"
    opts=(
      --unshare-all --share-net --die-with-parent
      --proc /proc --dev /dev --tmpfs /tmp
      --dev-bind-try /dev/dri /dev/dri
      --ro-bind-try /sys/dev/char /sys/dev/char
      --ro-bind-try /sys/devices /sys/devices
      --ro-bind-try /sys/class /sys/class
      --ro-bind-try /sys/bus /sys/bus
      --ro-bind /nix /nix
      --ro-bind /etc /etc
      --ro-bind /run/current-system /run/current-system
      --tmpfs "$XDG_RUNTIME_DIR"
      --bind "$sock" "$XDG_RUNTIME_DIR/wayland-0"
      --bind-try "$XDG_RUNTIME_DIR/pipewire-0" "$XDG_RUNTIME_DIR/pipewire-0"
      --bind-try "$XDG_RUNTIME_DIR/bus" "$XDG_RUNTIME_DIR/bus"
      --bind "$app_home" "$HOME"
      --chdir "$HOME"
      --setenv WAYLAND_DISPLAY wayland-0
      --unsetenv DISPLAY --unsetenv UMBRIEL_SOCKET
    )
    for dev in /dev/nvidia*; do
      [ -e "$dev" ] && opts+=( --dev-bind "$dev" "$dev" )
    done
    ${pkgs.bubblewrap}/bin/bwrap "''${opts[@]}" "$@"
  '';
in
{
  options.sam.wlrun.enable = lib.mkEnableOption "restricted wayland app launcher";

  config = lib.mkIf cfg.enable {
    home.packages = [ wlrun ];
  };
}
