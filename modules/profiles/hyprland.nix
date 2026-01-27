{ config, pkgs, lib, ... }:

{
  config = {
    # Display server and compositor

    # Hyprland window manager
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      package = pkgs.hyprland;
    };

    # Essential Wayland protocols and libraries
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
      config.common.default = "*";
    };

    # Session variables for Wayland and Hyprland
    environment.sessionVariables = {
      # Wayland
      WAYLAND_DISPLAY = "wayland-1";
      XDG_SESSION_TYPE = "wayland";
      XDG_CURRENT_DESKTOP = "Hyprland";
      
      # QT
      QT_QPA_PLATFORM = "wayland";
      QT_QPA_PLATFORMTHEME = "qt6ct";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

      # Electron/Ozone
      NIXOS_OZONE_WL = "1";

      # GTK
      GDK_BACKEND = "wayland,x11";

      # Java
      _JAVA_AWT_WM_NONREPARENTING = "1";

      # Nvidia (if needed in future)
      # LIBVA_DRIVER_NAME = "nvidia";
      # XDG_SCREENSHOTS_DIR = "$HOME/Pictures/Screenshots";
    };

    # Essential system packages for Hyprland
    environment.systemPackages = with pkgs; [
      # Hyprland utilities
      hyprland
      hyprpaper
      hyprlock
      hypridle
      hyprshot
      
      # Status bar
      waybar
      
      # App launcher
      wofi
      
      # Notifications
      dunst
      libnotify
      
      # Clipboard
      wl-clipboard
      cliphist
      
      # Screenshots
      grim
      slurp
      
      # Colors/display
      wlr-randr
      
      # Themes and appearance
      papirus-icon-theme
      gtk-engine-murrine
      gnome-themes-extra
      
      # Terminal
      kitty
      
      # Core utilities
      dbus
      systemd
    ];

    # Fonts
    fonts.packages = with pkgs; [
     
      fira-code
      jetbrains-mono
    ];

    # Audio configuration
    services.pipewire = {
      enable = true;
      audio.enable = true;
      pulse.enable = true;
      alsa.enable = true;
      jack.enable = false;
    };

    # Disable GNOME/Plasma/other DEs
    services.desktopManager.gnome.enable = lib.mkForce false;
    services.desktopManager.plasma6.enable = lib.mkForce false;
    services.desktopManager.cosmic.enable = lib.mkForce false;

    # Basic dbus setup
    services.dbus.enable = true;

    # Polkit for privilege escalation in Wayland
    security.polkit.enable = true;

    # Udev for input devices
    services.udev.enable = true;
    services.udev.packages = with pkgs; [
      libinput
    ];

    # GLib for app integration
    services.gvfs.enable = false;
  };
}
