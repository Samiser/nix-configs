let
  keys = import ../shared-modules/keys.nix;
  inherit (keys) sam nix-lab minecraft jelly radar;
in {
  "nomad-samba-credentials.age".publicKeys = [sam nix-lab];
  "hcloud-token.age".publicKeys = [sam];
  "caddy-cloudflare-key.age".publicKeys = [sam nix-lab minecraft jelly];
  "ssc-secrets.age".publicKeys = [sam nix-lab];
  "miniflux-admin-credentials.age".publicKeys = [sam nix-lab];
  "storagebox-credentials.age".publicKeys = [sam nix-lab jelly radar];
  "tailscale-auth-key.age".publicKeys = [sam radar];
  "mullvad-privkey.age".publicKeys = [sam radar];
  "markovi-discord-token.age".publicKeys = [sam nix-lab];
  "attic-jwt-secret.age".publicKeys = [sam nix-lab];
  "github-runner-sambee.age".publicKeys = [sam nix-lab];
}
