{
  nix = {
    distributedBuilds = true;

    buildMachines = [
      {
        hostName = "nix-lab.dove-delta.ts.net";
        sshUser = "sam";
        systems = ["x86_64-linux"];
        protocol = "ssh-ng";
        # ssh nix-lab nix show-config | grep "system-features"
        supportedFeatures = ["benchmark" "big-parallel" "kvm" "nixos-test"];
        # ssh nix-lab nproc
        maxJobs = 4;
      }
    ];

    linux-builder = {
      enable = true;
      ephemeral = true;
      maxJobs = 4;
      config = {
        virtualisation = {
          darwin-builder = {
            diskSize = 30 * 1024;
            memorySize = 4 * 1024;
          };
          cores = 4;
        };
      };
    };
  };
}
