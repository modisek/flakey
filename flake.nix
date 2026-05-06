{
  description = "Kgosi's nixos conf";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
    zen-browser.inputs.home-manager.follows = "home-manager";
    cursor.url = "github:TudorAndrei/cursor-nixos-flake";

  };

  outputs =
    {
      self,
      home-manager,
      nixpkgs,
      nixos-hardware,
      determinate,
      disko,
      zen-browser,
      cursor,
      ...
    }@inputs:
    {
      nixosModules = import ./modules { lib = nixpkgs.lib; };
      nixosConfigurations = {
    dell5510 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        disko.nixosModules.disko
        ./hosts/dell5510/configuration.nix
        home-manager.nixosModules.home-manager
        nixos-hardware.nixosModules.latitude-5510
      ];
    };

        lenovo = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [

            ./hosts/lenovo/configuration.nix
            home-manager.nixosModules.home-manager
            # nixos-cosmic.nixosModules.default
            determinate.nixosModules.default

            # chaotic.nixosModules.default

            (
              { pkgs, lib, ... }:
              {

                environment.systemPackages = [
                  # For debugging and troubleshooting Secure Boot.
                  #pkgs.sbctl
                  cursor.packages.x86_64-linux.cursor
                ];

                # Lanzaboote currently replaces the systemd-boot module.
                # This setting is usually set to true in configuration.nix
                # generated at installation time. So we force it to false
                # for now.

                specialisation = {

                  cosmic = {
                    configuration = {
                      system.nixos.tags = [ "cosmic" ];
                      services.desktopManager.gnome.enable = lib.mkForce false;
                      services.desktopManager.plasma6.enable = lib.mkForce false;
                      services.desktopManager.cosmic.enable = true;
                    };
                  };

                  kde = {
                    # inheritParentConfig = false;
                    configuration = {
                      system.nixos.tags = [ "kde" ];
                      services.desktopManager.gnome.enable = lib.mkForce false;
                      services.desktopManager.plasma6.enable = true;
                      # services.displayManager.plasma-login.enable = true;
                      # services.displayManager.gdm.enable = lib.mkForce false;

                      environment.sessionVariables = {
                        KWIN_USE_OVERLAYS = "1";
                      };
                      environment.systemPackages = with pkgs; [
                      ];
                    };
                  };

                  hyprland = {
                    configuration = {
                      system.nixos.tags = [ "hyprland" ];
                      imports = with inputs.self.nixosModules; [
                        profiles-hyprland
                        mixins-systemd_networkd
                        mixins-fonts
                        mixins-common_packages
                      ];


                      home-manager.users.kgosi = { ... }: {
                        programs.hyprland.enable = true;
                      };
                    };
                  };
                };

              }
            )

          ];
          specialArgs = { inherit inputs; };
        };

      };
    };
}
