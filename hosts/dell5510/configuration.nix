{ config, pkgs, inputs, ... }: {
  imports = with inputs.self.nixosModules; [
    ./disks.nix
    ./hardware-configuration.nix
    users-kgosi
    profiles-sway
    profiles-steam
    profiles-pipewire
    mixins-zram
    #mixins-i3status
    mixins-fonts
    mixins-bluetooth
    mixins-v4l2loopback
    mixins-vaapi-intel-hybrid-codec
    mixins-obs

  ];

  # clean logs older than 2d
  services.cron.systemCronJobs =
    [ "0 20 * * * root journalctl --vacuum-time=2d" ];

  systemd.coredump.enable = false;
  security.chromiumSuidSandbox.enable = true;

  # enable firejail
  programs.firejail.enable = true;

  # create system-wide executables firefox and chromium
  # that will wrap the real binaries so everything
  # work out of the box.
  programs.firejail.wrappedBinaries = {
    firefox = {
      executable = "${pkgs.lib.getBin pkgs.firefox}/bin/firefox";
      profile = "${pkgs.firejail}/etc/firejail/firefox.profile";
    };
    chromium = {
      executable = "${pkgs.lib.getBin pkgs.chromium}/bin/chromium";
      profile = "${pkgs.firejail}/etc/firejail/chromium.profile";
    };
  };

  services.fwupd.enable = true;
  services.fstrim.enable = true;

  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "vm.dirty_ratio" = 6;
  };

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

  nix = {
    # From flake-utils-plus
  };

  networking = {
    firewall = {
      # Syncthing ports
      allowedTCPPorts = [ 22000 ];
      allowedUDPPorts = [ 21027 22000 ];
    };
    hostName = "nomad";
    networkmanager.enable = true;

    #useNetworkd = true;

    #wireless = {
    # userControlled.enable = true;
    #enable = true;
    #interfaces = [ "wlp3s0" ];
    #};
    #useDHCP = false;
    #interfaces = {
    # "enp0s31f6".useDHCP = true;
    #"wlp3s0".useDHCP = true;
    #};
  };

  nix = {

    gc.automatic = true;
    gc.dates = "weekly";
    gc.options = "--delete-older-than 60d";
  };

  programs.hyprland.enable = true;

  services.syncthing.enable = true;
  services.thermald.enable = true;
  # tlp = {
  #    enable = true;
  #    settings = {
  #      PCIE_ASPM_ON_BAT = "powersupersave";
  #      CPU_SCALING_GOVERNOR_ON_AC = "performance";
  #      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  #      CPU_MAX_PERF_ON_AC = "100";
  #      CPU_MAX_PERF_ON_BAT = "30";
  #      STOP_CHARGE_THRESH_BAT1 = "95";
  #      STOP_CHARGE_THRESH_BAT0 = "95";
  #    };
  #  };
  #logind.killUserProcesses = true;

  boot = {
    kernelParams = [
      "i915.modeset=1"
      "i915.fastboot=1"
      "i915.enable_guc=2"
      "i915.enable_psr=1"
      "i915.enable_fbc=1"
      "i915.enable_dc=2"
      "mem_sleep_default=deep"
    ];
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      efi = { canTouchEfiVariables = true; };
    };
  };

  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    font = "latarcyrheb-sun32";
    keyMap = "us";
  };

  time.timeZone = "Africa/Gaborone";
  location.provider = "geoclue2";
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
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.onBoot = "ignore";
  virtualisation.libvirtd.qemu.package = pkgs.qemu_full;
  virtualisation.libvirtd.qemu.ovmf.enable = true;
  virtualisation.libvirtd.qemu.ovmf.packages =
    if pkgs.stdenv.isx86_64 then [ pkgs.OVMFFull.fd ] else [ pkgs.OVMF.fd ];
  virtualisation.libvirtd.qemu.swtpm.enable = true;
  virtualisation.libvirtd.qemu.swtpm.package = pkgs.swtpm;
  virtualisation.libvirtd.qemu.runAsRoot = false;
  virtualisation.spiceUSBRedirection.enable =
    true; # Note that this allows users arbitrary access to USB devices.
  environment.sessionVariables.LIBVIRT_DEFAULT_URI = [ "qemu:///system" ];

  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "btrfs";

  boot.binfmt.emulatedSystems = [ "x86_64-linux" "i686-linux" ];
  #services.flatpak.enable = true;
  environment.systemPackages = with pkgs; [
    firefox
    chromium
    mpv
    git
    stow
    neovim
    virt-manager
    tmux
    fzf
    zoxide
    curl
    curlie
    ffmpeg
    tig
    terraform
    awscli2
    helix
    palemoon-bin
    docker-compose
    spotify
    anydesk
    nixfmt
    magic-wormhole-rs
    pass
    gnupg
    powertop
    ulauncher
    wofi
    iwgtk
  ];
  nix.settings.experimental-features = [ "flakes" "nix-command" ];

  system.stateVersion = "22.11";
}

