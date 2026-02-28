{config, pkgs, ...}: {
  age.secrets.storagebox-credentials.file = ../../secrets/storagebox-credentials.age;

  fileSystems."/mnt/storagebox" = {
    device = "//u554215-sub1.your-storagebox.de/u554215-sub1";
    fsType = "cifs";
    options = [
      "credentials=${config.age.secrets.storagebox-credentials.path}"
      "uid=radarr"
      "gid=radarr"
      "file_mode=0660"
      "dir_mode=0770"
      "x-systemd.automount"
      "noauto"
      "_netdev"
    ];
  };

  environment.systemPackages = [pkgs.cifs-utils];
}
