{ config, lib, ... }:

{
  config = {
    # Use systemd-networkd instead of NetworkManager
    networking.useNetworkd = true;
    networking.useDHCP = false;

    # Disable conflicting network managers
    networking.networkmanager.enable = lib.mkForce false;
    services.connman.enable = false;

    # systemd-networkd configuration
    systemd.network = {
      enable = true;
      
      # DHCP configuration for all interfaces
      networks = {
        "10-dhcp" = {
          matchConfig.Name = "en* eth* wlan*";
          DHCP = "yes";
        };

        # Loopback interface
        "01-lo" = {
          matchConfig.Name = "lo";
          address = [
            "127.0.0.1/8"
            "::1/128"
          ];
        };
      };
    };

    # DNS configuration (fallback)
    networking.nameservers = [ "1.1.1.1" "8.8.8.8" "2606:4700:4700::1111" ];

    # Systemd-resolved for DNS
    services.resolved = {
      enable = true;
      dnssec = "allow-downgrade";
      dnsovertls = "no";
      fallbackDns = [ "1.1.1.1" "8.8.8.8" ];
    };

    # Firewall configuration
    networking.firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
      allowedUDPPorts = [];
    };

    # Enable IPv6
    networking.enableIPv6 = true;

    # Wireless support with iwd (lightweight)
    networking.wireless.iwd.enable = true;
    networking.wireless.iwd.settings = {
      General = {
        EnableNetworkConfiguration = true;
      };
    };

    # Systemd-timesyncd for NTP
    services.timesyncd = {
      enable = true;
      servers = [
        "0.nixos.pool.ntp.org"
        "1.nixos.pool.ntp.org"
        "2.nixos.pool.ntp.org"
        "3.nixos.pool.ntp.org"
      ];
    };
  };
}
