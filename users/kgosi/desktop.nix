{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ./modules/nnn.nix
    ./modules/kitty.nix
  ];
  home = {
    packages = with pkgs; [
      zathura
      pavucontrol
      wl-mirror
      vscode
    ];
  };



  xdg.enable = true;
}
