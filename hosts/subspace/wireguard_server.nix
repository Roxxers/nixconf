
{ lib, pkgs, ...}:
let wireguardPort = 51820;
in
{
  # enable NAT
  networking.nat.enable = true;
  networking.nat.externalInterface = "eth0";
  networking.nat.internalInterfaces = [ "wg0" ];
  networking.firewall = {
    allowedUDPPorts = [ wireguardPort ];
  };

  networking.wireguard.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg0 = {
      # Determines the IP address and subnet of the server's end of the tunnel interface.
      ips = [ "10.0.3.1/21" ];
      listenPort = wireguardPort;
      privateKeyFile = "/run/keys/wg_private";
      # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
      # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
      postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.0.0.0/21 -o enp0s4 -j MASQUERADE
      '';
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.0.0.0/21 -o enp0s4 -j MASQUERADE
      '';

      peers = [
        { # laser-moon
          publicKey = "L5CcXiZ3+cWq5BlZm1M3FygyOoIgMJOYQNVzkO7u8Bc=";
          presharedKeyFile = "/run/keys/wgpsk_laser-moon_subspace";
          allowedIPs = [ "10.0.0.10/32" ];
        }
        { # pixel grapheneOS
          publicKey = "X9dKW80aJ6igJDQf8cS5mvYEPXTvtmbTPpLMg5xIGjM=";
          presharedKeyFile = "/run/keys/wgpsk_pixel_subspace";
          allowedIPs = [ "10.0.0.11/32" ];
        }
        { # lesbos
          publicKey = "3G2ek0EbYBpn82Gvk5QU9qaqKTrA2QgtPSL1YgCX7Rw=";
          presharedKeyFile = "/run/keys/wgpsk_lesbos_subspace";
          allowedIPs = [ "10.0.0.2/32" ];
        }
      ];
    };
  };

}
