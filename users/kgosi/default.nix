{ config, lib, pkgs, inputs, ... }:

{
  # If we aren't headless, then load ./desktop.nix
  # TODO: This is janky and leads to infinite recursion errors if headless is
  # unset. It's an antipattern, but it's what I can do for now without a big
  # refactor.
  # https://discourse.nixos.org/t/conditionally-import-module-if-it-exists/17832/2
  # https://github.com/jonringer/nixpkgs-config/blob/cc2958b5e0c8147849c66b40b55bf27ff70c96de/flake.nix#L47-L82
  imports = [ ./desktop.nix ];

  home = {
    username = "kgosi";
    homeDirectory = "/home/kgosi";
    packages = with pkgs; [
      ripgrep
      unzip
      nodejs
      #go
      #gopls
      python3
      #zig
      intel-gpu-tools
      yt-dlp
      htop
      libwebp
      #gnome-firmware
      #google-chrome
      #gnomeExtensions.user-themes
      gnomeExtensions.tray-icons-reloaded
      #gnomeExtensions.vitals
      gnomeExtensions.dash-to-panel
      gnomeExtensions.sound-output-device-chooser
      # alacritty
      #gnome.gnome-terminal
      gnomeExtensions.caffeine
      #gnomeExtensions.gsconnect
      #gnomeExtensions.zen
      #gnome4x ui inprovements
      #gnome custom accent colors
      #gimp
      #inkscape
      #libreoffice
      #transmission
      #jdk
      #rnix-lsp
      #blender

      # apps

      gnome.dconf-editor
      gnome-extension-manager
      #gradience

      # useful utils
      nautilus-open-any-terminal

      # extensions
      gnomeExtensions.appindicator

      # gnomeExtensions.blur-my-shell
      # gnomeExtensions.extensions-sync
      gnomeExtensions.hibernate-status-button
      # gnomeExtensions.logo-menu
      gnomeExtensions.just-perfection

      # gnomeExtensions.pop-shell

      # gnomeExtensions.smart-auto-move
      # gnomeExtensions.space-bar
      gnomeExtensions.dash-to-dock
    
      vaultwarden


    ];
  };
  programs.fzf = { enable = true; };
  programs.zoxide = { enable = true; };
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  home.file.".tmux.conf".source = ../../files/tmux.conf;
  programs = {
    starship = {
      enable = true;
      enableBashIntegration = true;
      # settings = {
      #   username = {
      #     format = "user: [$user]($style) ";
      #     show_always = true;
      #   };
      #   shlvl = {
      #     disabled = false;
      #     format = "$shlvl ▼ ";
      #     threshold = 4;
      #   };
      # };
    };
    bash = {
      enable = true;
      initExtra = builtins.readFile ../../files/bashrc;
    };
  };

  gtk = {
    enable = true;

    cursorTheme = {
      name = "Numix-Cursor";
      package = pkgs.numix-cursor-theme;
    };
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

  # Use `dconf watch /` to track stateful changes you are doing and store them here.
  dconf.settings = {

    "org/gnome/desktop/applications/terminal" = {
      exec = "${pkgs.alacritty}/bin/alacritty";
    };

    "ca/desrt/dconf-editor" = {
      saved-pathbar-path = "/org/gnome/shell/extensions/pop-shell/";
      saved-view = "/org/gnome/shell/extensions/pop-shell/";
      show-warning = false;
      window-height = 1375;
      window-is-maximized = false;
      window-width = 2240;
    };

    "org/gnome/desktop/interface" = {
      clock-show-seconds = false;
      clock-show-weekday = true;
      color-scheme = "prefer-dark";

      enable-animations = true;
      enable-hot-corners = false;
      font-antialiasing = "grayscale";
      font-hinting = "slight";

      show-battery-percentage = true;
      toolkit-accessibility = false;
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" =
      {
        binding = "<Super>Return";
        command = "kgx";
        name = "Open Terminal";
      };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" =
      {
        binding = "<Control><Alt>Delete";
        command = "systemctl hibernate";
        name = "Hibernate";
      };

    "org/gnome/settings-daemon/plugins/power" = {
      power-button-action = "hibernate";
    };

    "org/gnome/shell/extensions/Logo-menu" = {
      hide-forcequit = true;
      hide-softwarecentre = true;
      menu-button-extensions-app = "com.mattjakeman.ExtensionManager.desktop";
      menu-button-icon-image = 23;
      menu-button-terminal = "alacritty";
      show-power-options = true;
    };

    "org/gnome/shell/extensions/appindicator" = {
      custom-icons = "@a(sss) []";
      legacy-tray-enabled = true;
    };

    "org/gnome/shell/extensions/blur-my-shell/applications" = {
      blur-on-overview = true;
    };

    "org/gnome/shell/extensions/blur-my-shell/overview" = {
      style-components = 2;
    };

    "org/gnome/shell/extensions/just-perfection" = {
      accessibility-menu = true;
      activities-button-icon-monochrome = true;
      app-menu = true;
      app-menu-icon = true;
      background-menu = true;
      calendar = true;
      clock-menu = true;
      dash = true;
      dash-icon-size = 0;
      double-super-to-appgrid = true;
      events-button = true;
      gesture = true;
      hot-corner = false;
      osd = true;
      panel = true;
      panel-arrow = true;
      panel-corner-size = 0;
      panel-in-overview = true;
      panel-notification-icon = false;
      power-icon = true;
      ripple-box = true;
      search = true;
      show-apps-button = true;
      startup-status = 1;
      theme = false;
      weather = true;
      window-demands-attention-focus = false;
      window-picker-icon = true;
      window-preview-caption = true;
      workspace = true;
      workspace-background-corner-size = 0;
      workspace-popup = true;
      workspaces-in-app-grid = true;
    };





    "org/gnome/shell/extensions/search-light" = {

      blur-background = true;
      blur-brightness = 0.6;
      blur-sigma = 200.0;
      border-radius = 3.0;
      entry-font-size = 1;
      monitor-count = 1;
      popup-at-cursor-monitor = true;
      scale-height = 0.1;
      scale-width = 0.1;
      shortcut-search = [ "<Super>a" ];
      show-panel-icon = true;
    };

    "org/gnome/shell/extensions/space-bar/behavior" = {
      smart-workspace-names = false;
    };

    "org/gnome/shell/extensions/space-bar/shortcuts" = {
      enable-move-to-workspace-shortcuts = true;
    };

    "org/gnome/desktop/wm/keybindings" = {
      activate-window-menu = [ "disabled" ];
      toggle-message-tray = [ "disabled" ];
      close = [ "<Super>x" ];
      maximize = [ "<Super>m" ];
      minimize = [ "<Super>comma" ];

      toggle-maximized = [ "<Super>Up" ];
      unmaximize = [ "disabled" ];
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "close,minimize,maximize:appmenu";
      num-workspaces = 5;
    };

    "org/gnome/desktop/notifications" = { show-in-lock-screen = false; };
    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      two-finger-scrolling-enabled = false;
    };

    # "org/gnome/shell" = {
    #   disable-user-extensions = false;
    #   # `gnome-extensions list` for a list
    #   enabled-extensions = [
    #     "user-theme@gnome-shell-extensions.gcampax.github.com"
    #     "trayIconsReloaded@selfmade.pl"

    #     "dash-to-panel@jderose9.github.com"
    #     "sound-output-device-chooser@kgshank.net"
    #     "space-bar@luchrioh"
    #     "caffeine@patapon.info"
    #     "gsconnect@andyholmes.github.io"
    #     "just-perfection-desktop@just-perfection"
    #   ];
    #   favorite-apps = [
    #     "firefox.desktop"
    #     "code.desktop"
    #     "org.gnome.Terminal.desktop"
    #     "spotify.desktop"
    #     "org.gnome.Nautilus.desktop"
    #   ];
    # };
    # "org/gnome/desktop/interface" = {
    #   color-scheme = "prefer-dark";
    #   enable-hot-corners = true;
    # };
    # # `gsettings get org.gnome.shell.extensions.user-theme name`

    # "org/gnome/desktop/wm/preferences" = { workspace-names = [ "Main" ]; };

    # "org/gnome/desktop/interface" = {
    #   clock-show-seconds = false;
    #   clock-show-weekday = true;

    #   font-antialiasing = "grayscale";
    #   font-hinting = "slight";

    # };
    # "org/gnome/desktop/wm/keybindings" = {
    #   activate-window-menu = [ "disabled" ];
    #   toggle-message-tray = [ "disabled" ];
    #   close = [ "<Super>q" ];
    #   maximize = [ "<Super>m" ];
    #   minimize = [ "<Super>comma" ];

    #   toggle-maximized = [ "<Super>Up" ];
    #   unmaximize = [ "disabled" ];
    # };
    # "org/gnome/desktop/wm/preferences" = {
    #   button-layout = "close,minimize,maximize:appmenu";
    #   num-workspaces = 10;
    # };

    # "org/gnome/desktop/notifications" = { show-in-lock-screen = false; };
    # "org/gnome/desktop/peripherals/touchpad" = {
    #   tap-to-click = true;
    #   two-finger-scrolling-enabled = false;
    # };

  };

 

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
   
    extensions = with pkgs.vscode-extensions;
      [
        bbenoist.nix
        ms-vscode-remote.remote-ssh
        github.vscode-pull-request-github
        editorconfig.editorconfig
        matklad.rust-analyzer
        mkhl.direnv
        jock.svg
        usernamehw.errorlens
        vadimcn.vscode-lldb
        bungcip.better-toml

      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [

        {
          name = "todo-tree";
          publisher = "Gruntfuggly";
          version = "0.0.215";
          sha256 = "sha256-WK9J6TvmMCLoqeKWh5FVp1mNAXPWVmRvi/iFuLWMylM=";
        }
      ] ++ (if pkgs.stdenv.isx86_64 then
        with pkgs.vscode-extensions; [ ms-python.python ]
      else
        [ ]);
  };
  #home.sessionVariables.GTK_THEME = "palenight";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";
}
