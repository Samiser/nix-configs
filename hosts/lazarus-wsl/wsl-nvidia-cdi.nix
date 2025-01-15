{
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
      daemon.settings = {
        features.cdi = true;
        cdi-spec-dirs = ["/home/sam/.cdi"];
      };
    };
    daemon.settings = {
      features.cdi = true;
    };
  };
  hardware = {
    nvidia = {
      modesetting.enable = true;
      nvidiaSettings = false;
      open = false;
    };
    nvidia-container-toolkit.enable = true;
  };
  services.xserver.videoDrivers = ["nvidia"];
}
