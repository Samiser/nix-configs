{config, ...}: {
  services =
    if config.hostConfig.vm
    then {
      qemuGuest.enable = true;
      spice-webdavd.enable = true;
      spice-vdagentd.enable = true;
    }
    else {};
}
