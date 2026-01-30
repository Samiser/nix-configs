{lib, ...}: {
  options.hostConfig = {
    gui.enable = lib.mkEnableOption "GUI programs";
    vm = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable VM guest services";
    };
  };
}
