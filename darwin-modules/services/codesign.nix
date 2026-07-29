# one-time setup:
#
#   tmp=$(mktemp -d)
#   openssl req -x509 -newkey rsa:2048 -days 3650 -nodes \
#     -keyout "$tmp/key.pem" -out "$tmp/cert.pem" \
#     -subj "/CN=nix-codesign" \
#     -addext "keyUsage=critical,digitalSignature" \
#     -addext "extendedKeyUsage=critical,codeSigning"
#   openssl pkcs12 -export -out "$tmp/cert.p12" \
#     -inkey "$tmp/key.pem" -in "$tmp/cert.pem" -passout pass:nix
#   sudo security import "$tmp/cert.p12" \
#     -k /Library/Keychains/System.keychain -P nix -T /usr/bin/codesign
#   sudo security add-trusted-cert -d -r trustRoot -p codeSign \
#     -k /Library/Keychains/System.keychain "$tmp/cert.pem"
#   rm -rf "$tmp"
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.sam.services.codesign;

  signDir = "/opt/nix-signed";
  identity = "nix-codesign";

  tools = {
    yabai = pkgs.yabai;
    skhd = pkgs.skhd;
    borders = pkgs.jankyborders;
  };

  mkWrapper = bin:
    pkgs.writeShellScriptBin bin ''
      exec ${signDir}/${bin} "$@"
    '';
in {
  options.sam.services.codesign.enable =
    lib.mkEnableOption "stable signed copies of TCC-sensitive binaries";

  config = lib.mkIf cfg.enable {
    services.yabai.package = mkWrapper "yabai";
    services.skhd.package = mkWrapper "skhd";
    services.jankyborders.package = mkWrapper "borders";

    system.activationScripts.preActivation.text = ''
      mkdir -p ${signDir}
      for src in ${lib.concatStringsSep " " (lib.mapAttrsToList (bin: pkg: "${pkg}/bin/${bin}") tools)}; do
        name=$(basename "$src")
        dst="${signDir}/$name"
        if ! cmp -s "$src" "$dst.orig"; then
          if ! /usr/bin/security find-certificate -c ${identity} /Library/Keychains/System.keychain >/dev/null 2>&1; then
            echo "error: '${identity}' certificate not found in the System keychain" >&2
            echo "see darwin-modules/services/codesign.nix for one-time setup instructions" >&2
            exit 1
          fi
          echo "codesigning $name into ${signDir}..." >&2
          cp -f "$src" "$dst.new"
          /usr/bin/codesign -f -s ${identity} "$dst.new"
          mv -f "$dst.new" "$dst"
          cp -f "$src" "$dst.orig"
        fi
      done
    '';
  };
}
