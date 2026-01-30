{config, lib, ...}: {
  config = lib.mkIf config.host.profile.vm {
    services = {
      qemuGuest.enable = true;
      spice-webdavd.enable = true;
      spice-vdagentd.enable = true;
    };
  };
}
