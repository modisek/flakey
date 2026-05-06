{ config, pkgs, ... }: {
  services.easyeffects.enable = true;

  # Directory for presets
  home.file.".config/easyeffects/output/preset.json".source = ../../../../files/preset.json;
}
