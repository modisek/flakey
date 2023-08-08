{ config, lib, pkgs, inputs, ... }: {
  imports = [
    #./modules/nnn.nix
    ./modules/kitty.nix
  ];
  home = {
    packages = with pkgs;
      [
        zathura

      ];
  };

  xdg.enable = true;
}
