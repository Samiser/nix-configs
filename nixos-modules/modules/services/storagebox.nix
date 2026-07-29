{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.storagebox;
in {
  options.services.storagebox = {
    enable = lib.mkEnableOption "Hetzner storage box CIFS mount";

    mountPoint = lib.mkOption {
      type = lib.types.path;
      default = "/mnt/storagebox";
      description = "Where to mount the share";
    };

    device = lib.mkOption {
      type = lib.types.str;
      default = "//u554215-sub1.your-storagebox.de/u554215-sub1";
      description = "CIFS share to mount";
    };

    user = lib.mkOption {
      type = lib.types.str;
      description = "Owner of the mounted files";
      example = "jellyfin";
    };

    group = lib.mkOption {
      type = lib.types.str;
      description = "Group of the mounted files";
      example = "jellyfin";
    };

    fileMode = lib.mkOption {
      type = lib.types.str;
      default = "0660";
      description = "Mode for files on the share";
    };

    dirMode = lib.mkOption {
      type = lib.types.str;
      default = "0770";
      description = "Mode for directories on the share";
    };

    extraOptions = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Additional CIFS mount options, e.g. caching tweaks";
      example = ["cache=loose" "actimeo=60"];
    };
  };

  config = lib.mkIf cfg.enable {
    age.secrets.storagebox-credentials.file = ../../../secrets/storagebox-credentials.age;

    fileSystems.${cfg.mountPoint} = {
      inherit (cfg) device;
      fsType = "cifs";
      options =
        [
          "credentials=${config.age.secrets.storagebox-credentials.path}"
          "uid=${cfg.user}"
          "gid=${cfg.group}"
          "file_mode=${cfg.fileMode}"
          "dir_mode=${cfg.dirMode}"
          "x-systemd.automount"
          "noauto"
          "_netdev"
        ]
        ++ cfg.extraOptions;
    };

    environment.systemPackages = [pkgs.cifs-utils];
  };
}
