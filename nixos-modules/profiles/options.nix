{lib, ...}: {
  options.host.profile = {
    desktop = lib.mkEnableOption "desktop profile";
    dev = lib.mkEnableOption "development tools";
    server = lib.mkEnableOption "server profile";
    vm = lib.mkEnableOption "VM guest services";
  };
}
