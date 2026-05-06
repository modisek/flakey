 {config, pkgs, inputs, lib, ...}: {
 # clean logs older than 2d
  services.cron.systemCronJobs = [ "-1 20 * * * root journalctl --vacuum-time=2d" ];

  systemd.coredump.enable = false;
  services.fwupd.enable = true;
  #services.fstrim.enable = true;
  services.tailscale.enable = true;
  services.flatpak.enable = true;

  # boot.kernel.sysctl = {
  #   "vm.swappiness" = 99;
  #   "vm.dirty_ratio" = 5;
  # };

  nix = {

    gc.automatic = true;
    gc.dates = "weekly";
    gc.options = "--delete-older-than 60d";
  };

  services.thermald.enable = true;
  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    font = "latarcyrheb-sun32";
    keyMap = "us";
  };

  time.timeZone = "Africa/Gaborone";
  location.provider = "geoclue2";

 }
