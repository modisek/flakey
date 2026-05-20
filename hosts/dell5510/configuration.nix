{ config, pkgs, inputs, lib, ... }: {
  imports = with inputs.self.nixosModules; [
    ./disk-config.nix
    # ./hardware-configuration.nix
    users-kgosi
    profiles-gnome
    profiles-pipewire
    mixins-zram
    mixins-fonts
    mixins-obs
    mixins-virtualization
    mixins-common_packages
    mixins-common
    mixins-services

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

  users.users.kgosi.extraGroups = [ "video" "render" ];

  networking = {
    firewall = {
      enable = true;
    };
    wireless = {
      iwd.enable = true;
    };
    hostName = "nomad";
    networkmanager.enable = true;
    networkmanager.wifi.backend = "iwd";
  };

  boot = {
    initrd.systemd.enable = true;
    kernelPackages = pkgs.linuxPackages_testing;
    kernelParams = [
      "i915.enable_guc=3"
      "mem_sleep_default=deep"
      "quiet"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      efi = { canTouchEfiVariables = true; };
    };
    supportedFilesystems = [ "btrfs" "ntfs" ];
    consoleLogLevel = 0;
    initrd.verbose = false;
    plymouth.enable = true;
  };
  hardware.enableAllFirmware = true;
  nixpkgs.config.allowUnfree = true;

  services.udev.extraRules = ''
    ACTION=="add|change", KERNEL=="sd[a-z]*|nvme[0-9]*n[0-9]*", ATTR{queue/scheduler}="mq-deadline"
  '';

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-compute-runtime
      intel-media-driver
      intel-vaapi-driver
    ];
  };

  services.ollama = {
    enable = true;
    package = pkgs.ollama;
  };

  services.pulseaudio.enable = false;

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
    clinfo
    intel-gpu-tools
    openvino
    (python3.withPackages (ps: with ps; [
      optimum-intel
      openvino-telemetry
      numpy
      pip
      virtualenv
    ]))
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
    ollama-cuda
  ];

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  nix.settings.substituters = lib.mkDefault [
    "https://nix-community.cachix.org"
    "https://cache.nixos.org/"
  ];
  nix.settings.trusted-public-keys = lib.mkDefault [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];
  nix.settings.experimental-features = [ "flakes" "nix-command" ];

  system.stateVersion = "24.11";
}
