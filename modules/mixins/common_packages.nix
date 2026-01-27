{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    stow
    neovim
    tmux
    fzf
    zoxide
    curl
    ffmpeg
    tig
    terraform
    awscli2
    helix
    nixfmt
    nil
    magic-wormhole-rs
    gnupg
    powertop
    bun
    deno
    nickel
    dive
    gnomeExtensions.tailscale-qs
    gnomeExtensions.tailscale-status
    gnomeExtensions.pano
    distrobox
    erlang
    elixir
    go
    gopls
    tail-tray
  ];
}
