{ config, pkgs, lib, ... }:

{
  options.programs.hyprland = {
    enable = lib.mkEnableOption "Hyprland window manager configuration";
  };

  config = lib.mkIf config.programs.hyprland.enable {
    # Hyprland configuration via home-manager
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        monitor = ",preferred,auto,1";
        
        env = [
          "XCURSOR_SIZE,24"
          "XCURSOR_THEME,Adwaita"
        ];

        input = {
          kb_layout = "us";
          kb_variant = "";
          kb_model = "";
          kb_options = "";
          kb_rules = "";
          follow_mouse = 1;
          touchpad = {
            natural_scroll = false;
          };
          sensitivity = 0;
        };

        gestures = {
          workspace_swipe = true;
          workspace_swipe_fingers = 3;
        };

        general = {
          gaps_in = 5;
          gaps_out = 20;
          border_size = 2;
          "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          "col.inactive_border" = "rgba(595959aa)";
          layout = "dwindle";
          allow_tearing = false;
        };

        decoration = {
          rounding = 10;
          blur = {
            enabled = true;
            size = 3;
            passes = 1;
          };
          drop_shadow = true;
          shadow_range = 4;
          shadow_render_power = 3;
          "col.shadow" = "rgba(1a1a1aee)";
        };

        animations = {
          enabled = true;
          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
          animation = [
            "windows, 1, 10, myBezier"
            "windowsOut, 1, 10, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };

        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };

        master = {
          new_is_master = true;
        };

        # Workspace binds
        workspace = [
          "1, monitor:eDP-1"
          "2, monitor:eDP-1"
          "3, monitor:eDP-1"
          "4, monitor:eDP-1"
          "5, monitor:eDP-1"
        ];

        # Keybindings
        bind = [
          "SUPER, Q, exec, kitty"
          "SUPER, C, killactive,"
          "SUPER, M, exit,"
          "SUPER, E, exec, dolphin"
          "SUPER, V, togglefloating,"
          "SUPER, SPACE, exec, wofi --show drun"
          "SUPER, P, pseudo,"
          "SUPER, J, togglesplit,"

          # Focus navigation
          "SUPER, left, movefocus, l"
          "SUPER, right, movefocus, r"
          "SUPER, up, movefocus, u"
          "SUPER, down, movefocus, d"

          # Workspace switching
          "SUPER, 1, workspace, 1"
          "SUPER, 2, workspace, 2"
          "SUPER, 3, workspace, 3"
          "SUPER, 4, workspace, 4"
          "SUPER, 5, workspace, 5"

          # Move window to workspace
          "SUPER SHIFT, 1, movetoworkspace, 1"
          "SUPER SHIFT, 2, movetoworkspace, 2"
          "SUPER SHIFT, 3, movetoworkspace, 3"
          "SUPER SHIFT, 4, movetoworkspace, 4"
          "SUPER SHIFT, 5, movetoworkspace, 5"

          # Screenshot
          "SUPER, S, exec, hyprshot -m region"
          "SUPER SHIFT, S, exec, hyprshot -m output"

          # Volume control
          ", XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%"
          ", XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%"
          ", XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
        ];

        binde = [
          # Resize windows
          "SUPER SHIFT, left, resizeactive, -10 0"
          "SUPER SHIFT, right, resizeactive, 10 0"
          "SUPER SHIFT, up, resizeactive, 0 -10"
          "SUPER SHIFT, down, resizeactive, 0 10"
        ];

        bindm = [
          # Mouse bindings
          "SUPER, mouse:272, movewindow"
          "SUPER, mouse:273, resizewindow"
        ];
      };

      extraConfig = ''
        # Startup applications
        exec-once = waybar
        exec-once = dunst
        exec-once = hyprpaper
        exec-once = hypridle

        # Source additional configs if needed
        # source = ~/.config/hypr/colors.conf
      '';
    };

    # Waybar configuration
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 30;
          modules-left = [ "hyprland/workspaces" ];
          modules-center = [ "hyprland/window" ];
          modules-right = [ "pulseaudio" "network" "cpu" "memory" "battery" "clock" ];

          "hyprland/workspaces" = {
            format = "{id}";
            on-scroll-up = "hyprctl dispatch workspace e+1";
            on-scroll-down = "hyprctl dispatch workspace e-1";
          };

          "hyprland/window" = {
            max-length = 50;
          };

          clock = {
            format = "{:%H:%M}";
            interval = 1;
          };

          cpu = {
            interval = 5;
            format = "CPU {usage}%";
          };

          memory = {
            interval = 5;
            format = "RAM {used:0.1f}G";
          };

          battery = {
            states = {
              good = 80;
              warning = 30;
              critical = 15;
            };
            format = "{icon} {capacity}%";
            format-icons = [ "" "" "" "" "" ];
          };

          pulseaudio = {
            format = "{icon} {volume}%";
            format-muted = "󰝟 {volume}%";
            format-icons = {
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              portable = "";
              car = "";
              default = [ "" "" "" ];
            };
            on-click = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
          };

          network = {
            format-wifi = "󰤨 {essid}";
            format-ethernet = "󰈀 Connected";
            format-disconnected = "󰤭 Disconnected";
            on-click = "iwctl";
          };
        };
      };

      style = ''
        * {
          border: none;
          border-radius: 0;
          font-family: monospace;
          font-size: 13px;
          min-height: 0;
        }

        window#waybar {
          background-color: #1e1e1e;
          color: #ffffff;
        }

        #workspaces button {
          padding: 5px 8px;
          margin: 0 2px;
          background-color: #2d2d2d;
          color: #888888;
        }

        #workspaces button.active {
          background-color: #33ccff;
          color: #000000;
        }

        #window {
          padding: 0 10px;
          color: #cccccc;
        }

        #battery, #cpu, #memory, #pulseaudio, #network, #clock {
          padding: 5px 10px;
          margin-right: 5px;
          background-color: #2d2d2d;
          color: #cccccc;
        }

        #battery.critical:not(.charging) {
          background-color: #ff4444;
          color: #ffffff;
        }
      '';
    };

    # Dunst notification daemon
    services.dunst = {
      enable = true;
      settings = {
        global = {
          monitor = 0;
          geometry = "300x5-5+5";
          transparency = 10;
          frame_color = "#33ccff";
          font = "Monospace 10";
        };
      };
    };

    # Hyprpaper for wallpaper
    services.hyprpaper = {
      enable = true;
      settings = {
        preload = [ "~/.config/hypr/wallpaper.png" ];
        wallpaper = [ "eDP-1,~/.config/hypr/wallpaper.png" ];
      };
    };

    # Home packages for Hyprland
    home.packages = with pkgs; [
      pcmanfm
    ];
  };
}
