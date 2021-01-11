{ config, lib, pkgs, ... }: 
let cfg = config.roxie.subspace;
in with lib;
{
  options = {
    roxie.subspace = {
      enable = mkEnableOption "Enables Subspace wireguard intranet vpn";
      ips = mkOption {
        type = with types; listOf str;
        description = "IPs and subnets for the client to use and access";
      };
      extraPeers = mkOption {
        type = with types; listOf attrs;
        description = "Add extra peers, must be the same format for the wireguard interface peers list";
        default = [];
      };
      listenPort = mkOption {
        default = null;
        type = with types; nullOr int;
        example = 51820;
        description = ''
          16-bit port for listening. Optional; if not specified,
          automatically generated based on interface name.
        '';
      };
      subspacePresharedKeyFile = mkOption {
        type = with types; nullOr str;
        default = null;
      };
      privateKeyFile = mkOption {
        type = with types; str;
        default = "";
      };
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedUDPPortRanges = [
      { from = cfg.listenPort; to = cfg.listenPort; }
    ];
    networking.wireguard.interfaces = {
      subspace = {
        ips = cfg.ips;
        generatePrivateKeyFile = true;
        privateKeyFile = cfg.privateKeyFile;
        listenPort = cfg.listenPort;
        peers = [
          { # Default subspace peer for server access
            publicKey = "/34G9jncaupxeWg2mGvFsectLHMRN2/K4jB/LBL7mE8=";
            allowedIPs = [ "10.0.3.1/32" "10.0.0.11/32" ];
            endpoint = "176.58.101.107:51820";
            presharedKeyFile = cfg.subspacePresharedKeyFile;
            persistentKeepalive = 25;
          }
        ] ++ cfg.extraPeers;
      };
    };
  };
}