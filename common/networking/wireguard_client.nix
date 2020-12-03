{ config, lib, pkgs, ... }: 
let cfg = config.roxie.subspace;
in with lib;
{
  options = {
    roxie.subspace = {
      enable = mkEnableOption "Installs go packages";
      ips = mkOption {
        type = types.listOf types.str;
        description = "IPs and subnets for the client to use and access";
      };
      # extraPeers = mkOption {
      #   type = types.listOf types.attrs;
      #   description = "Add extra peers, must be the same format for the wireguard interface peers list";
      # };
    };
  };

  config = mkIf cfg.enable {
    networking.wireguard.interfaces = {
      subspace = {
        ips = cfg.ips;
        generatePrivateKeyFile = true;
        privateKeyFile = "/root/wg/private";
        peers = [
          { # Default subspace peer for server access
            publicKey = "/34G9jncaupxeWg2mGvFsectLHMRN2/K4jB/LBL7mE8=";
            allowedIPs = [ "10.0.0.0/21"];
            endpoint = "176.58.101.107:51820";
            persistentKeepalive = 25;
          }
        ]; #++ cfg.extraPeers;
      };
    };
  };
}