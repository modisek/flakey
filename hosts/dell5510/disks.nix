{ pkgs, config, ... }:
{
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems = [ "btrfs"];
  hardware.enableAllFirmware = true;
  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
 
    boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-uuid/6c983a8e-4168-457e-810e-537e74d29bc7";
      preLVM = true;
};
};
}
