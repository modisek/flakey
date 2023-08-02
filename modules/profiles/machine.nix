{
    virtualisation.libvirtd.enable = true;
    virtualisation.libvirtd.onBoot = "ignore";
    virtualisation.libvirtd.qemu.package = pkgs.qemu_full;
    virtualisation.libvirtd.qemu.ovmf.enable = true;
    virtualisation.libvirtd.qemu.ovmf.packages = if pkgs.stdenv.isx86_64 then [ pkgs.OVMFFull.fd ] else [ pkgs.OVMF.fd ];
    virtualisation.libvirtd.qemu.swtpm.enable = true;
    virtualisation.libvirtd.qemu.swtpm.package = pkgs.swtpm;
    virtualisation.libvirtd.qemu.runAsRoot = false;
    virtualisation.spiceUSBRedirection.enable = true; # Note that this allows users arbitrary access to USB devices. 
    environment.sessionVariables.LIBVIRT_DEFAULT_URI = [ "qemu:///system" ];

    virtualisation.podman.enable = true;
}