{config, ...}: {
  services.printing.enable = !config.hostConfig.vm;
}
