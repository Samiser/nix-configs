# VM guest services (QEMU/Spice)
{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.hostConfig.vm {
    services.qemuGuest.enable = true;
    services.spice-webdavd.enable = true;
    services.spice-vdagentd.enable = true;
  };
}
