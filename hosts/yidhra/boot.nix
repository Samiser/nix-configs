_: {
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
    };

    kernelParams = [ "mem_sleep_default=s2idle" ];
  };
}
