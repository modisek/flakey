{ config, inputs, ... }:
{
  users.users.kgosi= {
    isNormalUser = true;
    extraGroups = [
      "input"
      "lp"
      "wheel"
      "dialout"
	    "networkmanager"
      "libvirtd" 
      "qemu-libvirtd" 
      "kvm"
      "disk"
      "docker"
    ];
      };
}
