{home-manager, ...}: {
  imports = [
    home-manager.darwinModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.sam = {
          imports = [
            ../../common/home-manager/git
            ../../common/home-manager/zsh
          ];

          home = {
            username = "sam";
            stateVersion = "25.05";
          };

          sam = {
            git.enable = true;
            zsh.enable = true;
          };
        };
      };
    }
  ];
}
