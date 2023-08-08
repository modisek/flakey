{ config, pkgs, lib, ... }:

{
  config = {
    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.displayManager.autoLogin.enable = false;
    services.xserver.desktopManager.gnome.enable = true;
    environment.gnome.excludePackages = (with pkgs;
      [

        gnome-tour
      ]) ++ (with pkgs.gnome; [
        cheese # webcam tool
        gnome-music
        gedit # text editor
        #epiphany # web browser
        # email reader
        gnome-characters
        tali # poker game
        iagno # go game
        hitori # sudoku game
        atomix # puzzle game
        yelp # Help view
        gnome-contacts
        gnome-initial-setup
      ]);

    # So gtk themes can be set
    programs.dconf.enable = true;
    services.dbus.packages = with pkgs; [ dconf ];

    hardware.opengl.driSupport = true;
    #hardware.steam-hardware.enable = true;
    #hardware.xpadneo.enable = true;

    #systemd.services.spotifyd.enable = true;

    # These should only be GUI applications that are desired systemwide
    environment.systemPackages = with pkgs;
      [

        gnome.gnome-tweaks

      ] ++ (if stdenv.isx86_64 then
        [
          exa

        ]
      else if stdenv.isAarch64 then
        [ spotifyd ]
      else
        [ ]);

    services.printing.enable = true;
  };
}

# let
#   bemenuAskpass = pkgs.writeShellScript "bemenuAskpass.sh" ''
#     ${pkgs.bemenu}/bin/bemenu \
#         --prompt "$1" \
#         --password \
#         --no-exec \
#         </dev/null
#   '';
# in
# {
#   imports = [
#     ../mixins/mako.nix
#     ../mixins/sway.nix
#     ../mixins/wlsunset.nix
#     ../mixins/i3status.nix
#   ];
#   config = {
#     services.dbus.packages = with pkgs; [ dconf ];
#     programs.light.enable = true;

#     xdg = {
#       portal = {
#         enable = true;
#         extraPortals = with pkgs; [
#           xdg-desktop-portal-wlr
#           #xdg-desktop-portal-gtk
#         ];
#       };
#     };

#     # The NixOS option 'programs.sway.enable' is needed to make swaylock work,
#     # since home-manager can't set PAM up to allow unlocks, along with some
#     # other quirks.
#     programs.sway.enable = true;

#     fonts.fonts = with pkgs; [ terminus_font_ttf font-awesome ];
#     home-manager.users.kgosi= { pkgs, ... }: {

#       # Block auto-sway reload, Sway crashes if allowed to reload this way.
#       xdg.configFile."sway/config".onChange = lib.mkForce "";

#       home.sessionVariables = {
#         SSH_ASKPASS="${bemenuAskpass}";
#         MOZ_ENABLE_WAYLAND = "1";
#         MOZ_USE_XINPUT2 = "1";
#         #WLR_DRM_NO_MODIFIERS = "1";
#         SDL_VIDEODRIVER = "wayland";
#         QT_QPA_PLATFORM = "wayland";
#         QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
#         _JAVA_AWT_WM_NONREPARENTING = "1";
#         XDG_SESSION_TYPE = "wayland";
#         XDG_CURRENT_DESKTOP = "sway";
#       };
#       home.packages = with pkgs; [
#         wl-clipboard
#         imv
#         i3status
#       ];
#     };
#   };
# }
