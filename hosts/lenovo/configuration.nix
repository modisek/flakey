{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  imports = with inputs.self.nixosModules; [
    # ./hardware-configuration.nix
    users-kgosi
    profiles-sway
    profiles-pipewire
    mixins-zram
    # mixins-i3status
    mixins-fonts
    #mixins-bluetooth
    #mixins-v4l2loopback
    # mixins-vaapi-intel-hybrid-codec
    mixins-obs
    mixins-virtualization
    mixins-common_packages
    mixins-common

  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users = import "${inputs.self}/users";
    extraSpecialArgs = {
      inherit inputs;
      headless = false;
    };
  };

  users.users.kgosi.extraGroups = [ "video" ];

  networking = {
    firewall = {

    };
    wireless = {
      iwd.enable = true;
    };
    hostName = "nomad";
    networkmanager.enable = true;
    networkmanager.wifi.backend = "iwd";
  };

  nixpkgs.config.allowUnfree = true;

  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs.linuxPackages_testing;
  boot = {
    kernelParams = [
      "i915.modeset=1"
      "i915.fastboot=1"
      "i915.enable_guc=3"
      "i915.enable_psr=1"
      "i915.enable_fbc=1"
      "i915.enable_dc=2"
      "mem_sleep_default=deep"
      "quiet"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "boot.shell_on_fail"
      "intel_pstate=passive"
      "pcie_aspm=force"
      "scsi_mod.use_blk_mq=1"
    ];
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      efi = {
        canTouchEfiVariables = true;
      };
    };
  };
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;
  boot.plymouth.enable = true;

  boot.initrd.luks.devices."luks-3011b93d-b77f-4bfd-9bce-e017cd20ee87".device =
    "/dev/disk/by-uuid/3011b93d-b77f-4bfd-9bce-e017cd20ee87";

  hardware = {
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        vpl-gpu-rt

      ];
    };

  };
  services.pulseaudio.enable = false;
  system.activationScripts = {
    rfkillUnblockWlan = {
      text = ''
        rfkill unblock wlan
      '';
      deps = [ ];
    };
  };

  programs.firefox.enable = true;
  programs.kdeconnect.enable = true;
  environment.systemPackages = with pkgs; [
    mpv
    podman-compose
    podman-desktop
    curlie
    spotify
    yarn
    google-chrome
    dotnetCorePackages.sdk_9_0_1xx-bin
    dotnet-ef
    ni
    warp-terminal
    kdePackages.francis
  ];

  nix.settings.substituters = lib.mkDefault [
    "https://nix-community.cachix.org"
    "https://cache.nixos.org/"
  ];
  nix.settings.trusted-public-keys = lib.mkDefault [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];
  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
  ];

  system.stateVersion = "23.05";
}
