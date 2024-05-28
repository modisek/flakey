{
  description = "Kgosi's nixos conf";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
   
  };

  outputs =
    { self
    , home-manager,
  
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
