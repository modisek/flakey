{
  description = "Kgosi's nixos conf";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    { self, home-manager, nixos-cosmic, nixpkgs,
    # chaotic
    # ,
     ...
    } @ inputs: {
      nixosModules = import ./modules { lib = nixpkgs.lib; };
            nixosConfigurations = {
        dell5510 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
          {
                    nix.settings = {
                      substituters = [ "https://cosmic.cachix.org/" ];
                      trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
                    };
                  }
            ./hosts/dell5510/configuration.nix
            home-manager.nixosModules.home-manager
            nixos-cosmic.nixosModules.default

            # chaotic.nixosModules.default

             ({ pkgs, lib, ... }: {

            environment.systemPackages = [
              # For debugging and troubleshooting Secure Boot.
              #pkgs.sbctl
            ];

            # Lanzaboote currently replaces the systemd-boot module.
            # This setting is usually set to true in configuration.nix
            # generated at installation time. So we force it to false
            # for now.



          })

          ];
          specialArgs = { inherit inputs; };
        };


      };
    };
}
