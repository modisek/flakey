{
  description = "Kgosi's nixos conf";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , home-manager
    , nixpkgs
    , ...
    } @ inputs: {
      nixosModules = import ./modules { lib = nixpkgs.lib; };
            nixosConfigurations = {
        dell5510 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/dell5510/configuration.nix
            home-manager.nixosModules.home-manager
       
          ];
          specialArgs = { inherit inputs; };
        };
     
       
      };
    };
}
