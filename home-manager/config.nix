{lib, ...}: {
  options.gui = {
    enable = lib.mkEnableOption "enable GUI programs";
  };
}
