{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.host.profile.desktop {
    hostConfig.gui.enable = true;

    hardware.graphics.enable = true;

    services.pipewire = {
      enable = true;
      pulse.enable = true;
    };

    fonts = {
      packages = with pkgs; [nerd-fonts.jetbrains-mono];
      fontconfig.defaultFonts.monospace = ["JetBrainsMono Nerd Font Mono"];
    };

    programs._1password.enable = true;
    programs._1password-gui.enable = true;

    environment.systemPackages = with pkgs;
      [
        _1password-cli
        acpi
        alacritty
        arandr
        chromium
        feh
        ffmpeg
        ghostty.terminfo
        gimp
        godot_4
        gotop
        imagemagick
        mpv
        mupdf
        neofetch
        obsidian
        peek
        playerctl
        scrot
        xclip
      ]
      ++ lib.optionals (pkgs.stdenv.hostPlatform.system == "x86_64-linux") [
        discord
        spotify
        steam
      ];

    nixpkgs.config.permittedInsecurePackages = ["python-2.7.18.8" "electron-24.8.6"];

    virtualisation.docker.enable = true;
  };
}
