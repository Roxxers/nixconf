
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
      privateKeyFile = "/root/wg/private";
      # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
      # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
      postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.0.0.0/21 -o eth0 -j MASQUERADE
      '';
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.0.0.0/21 -o eth0 -j MASQUERADE
      '';

      peers = [
        { # laser-moon
          publicKey = "L5CcXiZ3+cWq5BlZm1M3FygyOoIgMJOYQNVzkO7u8Bc=";
          allowedIPs = [ "10.0.0.0/21" ];
        }
        { # pixel grapheneOSni
          publicKey = "LKwutVs6UpJTmoEDa6oJVrYe1HNVNaJV6V1EyJhVxiY=";
          allowedIPs = [ "10.0.0.0/21" ];
        }
      ];
    };
  };

}