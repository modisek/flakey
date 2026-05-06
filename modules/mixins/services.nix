{ pkgs, ... }: {
  # Profile-sync-daemon
  services.psd.enable = true;

  # Bpftune
  # services.bpftune.enable = true;

  # Sched-ext (SCX_EXT)
  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
  };

  # Blocky (DoH)
  services.blocky = {
    enable = true;
    settings = {
      ports = {
        dns = 53;
        http = 4000;
      };
      upstreams = {
        groups = {
          default = [
            "https://1.1.1.1/dns-query"
            "https://8.8.8.8/dns-query"
          ];
        };
      };
      # Example blocking
      blocking = {
        blackLists = {
          ads = [ "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts" ];
        };
        clientGroupsBlock = {
          default = [ "ads" ];
        };
      };
    };
  };

  # Anacity Cpp - Placeholder, need to know how to install it
  # environment.systemPackages = [ pkgs.anacity ];

}
