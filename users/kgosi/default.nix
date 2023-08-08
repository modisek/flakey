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
      go
      python3
      zig
      rustc
      cargo
      intel-gpu-tools
      yt-dlp
      htop
      libwebp
      gnome-firmware
      google-chrome
      gnomeExtensions.user-themes
      gnomeExtensions.tray-icons-reloaded
      gnomeExtensions.vitals
      gnomeExtensions.dash-to-panel
      gnomeExtensions.sound-output-device-chooser
      gnomeExtensions.space-bar
      gnomeExtensions.just-perfection
      gnome.gnome-terminal
      gnomeExtensions.caffeine
      gnomeExtensions.gsconnect
      gnomeExtensions.just-perfection
      libreoffice
      transmission
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
      settings = {
        username = {
          format = "user: [$user]($style) ";
          show_always = true;
        };
        shlvl = {
          disabled = false;
          format = "$shlvl ▼ ";
          threshold = 4;
        };
      };
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
    "org/gnome/shell" = {
      disable-user-extensions = false;
      # `gnome-extensions list` for a list
      enabled-extensions = [
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "trayIconsReloaded@selfmade.pl"

        "dash-to-panel@jderose9.github.com"
        "sound-output-device-chooser@kgshank.net"
        "space-bar@luchrioh"
        "caffeine@patapon.info"
        "gsconnect@andyholmes.github.io"
        "just-perfection-desktop@just-perfection"
      ];
      favorite-apps = [
        "firefox.desktop"
        "code.desktop"
        "org.gnome.Terminal.desktop"
        "spotify.desktop"
        "org.gnome.Nautilus.desktop"
      ];
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = true;
    };
    # `gsettings get org.gnome.shell.extensions.user-theme name`

    "org/gnome/desktop/wm/preferences" = { workspace-names = [ "Main" ]; };

    "org/gnome/desktop/interface" = {
      clock-show-seconds = false;
      clock-show-weekday = true;

      font-antialiasing = "grayscale";
      font-hinting = "slight";

    };
    "org/gnome/desktop/wm/keybindings" = {
      activate-window-menu = [ "disabled" ];
      toggle-message-tray = [ "disabled" ];
      close = [ "<Super>q" ];
      maximize = [ "<Super>m" ];
      minimize = [ "<Super>comma" ];

      toggle-maximized = [ "<Super>Up" ];
      unmaximize = [ "disabled" ];
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "close,minimize,maximize:appmenu";
      num-workspaces = 10;
    };

    "org/gnome/desktop/notifications" = { show-in-lock-screen = false; };
    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      two-finger-scrolling-enabled = false;
    };

  };

  programs.fish.enable = true;

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    userSettings = {
      "workbench.colorTheme" = "Dark Modern";
      "terminal.integrated.scrollback" = 10000;
      "editor.formatOnSave" = true;
    };
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
  home.stateVersion = "20.03";
}
