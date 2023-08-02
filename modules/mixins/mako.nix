{ pkgs, ... }:

{
  config = {
    home-manager.users.kgosi= { pkgs, ... }: {
      services.mako = {
        enable = true;
        font = "Terminus";
      };
    };
  };
}
