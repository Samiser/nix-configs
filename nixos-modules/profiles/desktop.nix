# Desktop profile - GUI workstations
{
  pkgs,
  lib,
  config,
  ...
}: {
  # Enable GUI
  hostConfig.gui.enable = true;

  # Graphics
  hardware.graphics.enable = true;

  # Audio
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Fonts
  fonts = {
    packages = with pkgs; [nerd-fonts.jetbrains-mono];
    fontconfig = {
      defaultFonts = {
        monospace = ["JetBrainsMono Nerd Font Mono"];
      };
    };
  };

  # 1Password
  programs._1password.enable = true;
  programs._1password-gui.enable = true;

  # Desktop packages
  environment.systemPackages = with pkgs;
    [
      alacritty
      arandr
      chromium
      feh
      gimp
      godot_4
      mpv
      mupdf
      scrot
      obsidian
      peek
    ]
    ++ lib.optionals (pkgs.stdenv.hostPlatform.system == "x86_64-linux") [
      spotify
      steam
      discord
    ];

  nixpkgs.config.permittedInsecurePackages = ["python-2.7.18.8" "electron-24.8.6"];

  virtualisation.docker.enable = true;
}
