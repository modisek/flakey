{ config, pkgs, inputs, lib, ... }: {
  imports = with inputs.self.nixosModules; [
    ./disks.nix
    ./hardware-configuration.nix
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

  ];

  # clean logs older than 2d
  services.cron.systemCronJobs =
    [ "0 20 * * * root journalctl --vacuum-time=2d" ];

  systemd.coredump.enable = false;
  services.fwupd.enable = true;
  services.fstrim.enable = true;
  services.tailscale.enable = true;
  services.flatpak.enable = true;

  # boot.kernel.sysctl = {
  #   "vm.swappiness" = 100;
  #   "vm.dirty_ratio" = 6;
  # };

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

  nix = {

    gc.automatic = true;
    gc.dates = "weekly";
    gc.options = "--delete-older-than 60d";
  };

  programs.hyprland.enable = true;
  # programs.hikari.enable = true;
services.openssh.settings.X11Forwarding = true;
  services.thermald.enable = true;
services.gnome.gnome-keyring.enable = true;

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

  system.activationScripts = {
    rfkillUnblockWlan = {
      text = ''
      rfkill unblock wlan
      '';
      deps = [];
    };
  };

  virtualisation.libvirtd.enable = false;
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

  #boot.binfmt.emulatedSystems = [ "x86_64-linux" "i686-linux" ];

  programs.firefox.enable = true;

  security.tpm2.enable = true;
  security.tpm2.tctiEnvironment.enable = true;
  environment.systemPackages = with pkgs; [

    #mpv
    git
    stow
    neovim
    #virt-manager
    tmux
    fzf
    zoxide
    curl
    # curlie
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
    # ulauncher
    wofi
    bun
    nvd
    deno
    waybar
    caddy
    pulumi-bin
    pinentry-gnome
    nickel
    jetbrains.idea-community
    jetbrains.jdk
    dive
    hikari
    #process-compose
    keepassxc
    git-credential-keepassxc
    gnomeExtensions.tailscale-qs
    gnomeExtensions.tailscale-status
    # glib_git
    #lapce
    #gns3-gui
    #ciscoPacketTracer8
    
    pcmanfm
  microsoft-edge-dev 
   microsoft-edge 
  gnomeExtensions.pano
  distrobox
  erlang
  elixir

   
  ];

  nix.settings.substituters = lib.mkDefault [
    "https://nix-community.cachix.org"
    "https://cache.nixos.org/"
  ];
  nix.settings.trusted-public-keys = lib.mkDefault [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];
  nix.settings.experimental-features = [ "flakes" "nix-command" ];

  system.stateVersion = "22.11";
}

