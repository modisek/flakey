{ config, pkgs, inputs, lib, ... }: {
  imports = with inputs.self.nixosModules; [
    ./disks.nix
    ./hardware-configuration.nix
    users-kgosi
    profiles-sway
    profiles-pipewire
    mixins-zram
    mixins-fonts
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

  boot = {
    kernelParams = [
      "i915.modeset=1"
      "i915.fastboot=1"
      "i915.enable_guc=2"
      "i915.enable_psr=1"
      "i915.enable_fbc=1"
      "i915.enable_dc=2"
      "mem_sleep_default=deep"
      "quiet"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "boot.shell_on_fail"
    ];
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      efi = { canTouchEfiVariables = true; };
    };
  };
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;
  boot.plymouth.enable = true;

  
  hardware = {
    opengl = {
      driSupport = true;
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)

      ];
    };
    trackpoint = {
      enable = true;
      sensitivity = 255;
    };
    pulseaudio.enable = false;
  };

  system.activationScripts = {
    rfkillUnblockWlan = {
      text = ''
      rfkill unblock wlan
      '';
      deps = [];
    };
  };

  programs.firefox.enable = true;

  security.tpm2.enable = true;
  security.tpm2.tctiEnvironment.enable = true;
  environment.systemPackages = with pkgs; [
    docker-compose
    spotify
    caddy
    pulumi-bin
    keepassxc
    git-credential-keepassxc
    wofi
    waybar
    nvd
    pcmanfm
  ];

  nix.settings.substituters = lib.mkDefault [
    "https://nix-community.cachix.org"
    "https://cache.nixos.org/"
  ];
  nix.settings.trusted-public-keys = lib.mkDefault [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];
  nix.settings.experimental-features = [ "flakes" "nix-command" ];

  system.stateVersion = "23.05";
}

