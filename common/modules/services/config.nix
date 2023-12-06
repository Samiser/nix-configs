{ lib, config, pkgs, ... }:

with lib;
with types; {
  options = {
    hostConfig = {
      autologin = {
        user = mkOption {
          type = nullOr str;
          default = null;
          description = ''
            X session user
          '';
        };
        session = mkOption {
          type = nullOr str;
          default = null;
          description = ''
            X session type
          '';
        };
      };
    };
  };
}
