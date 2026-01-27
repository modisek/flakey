{ pkgs, ... }:

{
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.onBoot = "ignore";
  virtualisation.libvirtd.qemu.package = pkgs.qemu_full; 
  virtualisation.libvirtd.qemu.runAsRoot = false;
  virtualisation.spiceUSBRedirection.enable = true;
  environment.sessionVariables.LIBVIRT_DEFAULT_URI = [ "qemu:///system" ];

  virtualisation.podman.enable = true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" "riscv64-linux" ];

  programs.virt-manager.enable = true;
}
