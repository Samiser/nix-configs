_: {
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
    };

    # suspend-to-idle: this board's S3 implementation is unreliable
    kernelParams = [ "mem_sleep_default=s2idle" ];
  };
}
