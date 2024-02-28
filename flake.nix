{
  description = "Kgosi's nixos conf";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";

      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , home-manager,
    lanzaboote,
     nixpkgs,
    # chaotic
    # ,
     ...
    } @ inputs: {
      nixosModules = import ./modules { lib = nixpkgs.lib; };
            nixosConfigurations = {
        dell5510 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/dell5510/configuration.nix
            home-manager.nixosModules.home-manager
            lanzaboote.nixosModules.lanzaboote
            # chaotic.nixosModules.default

             ({ pkgs, lib, ... }: {

            environment.systemPackages = [
              # For debugging and troubleshooting Secure Boot.
              pkgs.sbctl
            ];

            # Lanzaboote currently replaces the systemd-boot module.
            # This setting is usually set to true in configuration.nix
            # generated at installation time. So we force it to false
            # for now.
            boot.loader.systemd-boot.enable = lib.mkForce false;

            boot.lanzaboote = {
              enable = true;
              pkiBundle = "/etc/secureboot";
            };
          })
       
          ];
          specialArgs = { inherit inputs; };
        };
     
       
      };
    };
}
