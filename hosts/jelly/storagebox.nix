{
  config,
  pkgs,
  ...
}: {
  age.secrets.storagebox-credentials.file = ../../secrets/storagebox-credentials.age;

  fileSystems."/mnt/storagebox" = {
    device = "//u554215-sub1.your-storagebox.de/u554215-sub1";
    fsType = "cifs";
    options = [
      "credentials=${config.age.secrets.storagebox-credentials.path}"
      "uid=jellyfin"
      "gid=jellyfin"
      "file_mode=0640"
      "dir_mode=0750"
      "x-systemd.automount"
      "noauto"
      "_netdev"
      "hard"
      "actimeo=60"
      "cache=loose"
      "rsize=4194304"
      "wsize=4194304"
    ];
  };

  environment.systemPackages = [pkgs.cifs-utils];
}
