{ config, lib, pkgs, inputs, ... }: {
  imports = [
    #./modules/nnn.nix
    ./modules/kitty.nix
    ./modules/hyprland.nix
  ];
  home = {
    packages = with pkgs;
      [
        zathura

      ];
  };

  xdg.enable = true;
}
