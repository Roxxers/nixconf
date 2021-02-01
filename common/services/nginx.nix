{ config, lib, pkgs, ... }: 
let cfg = config.roxie.services.nginx;
in with lib; {
  options = {
    roxie.services.nginx = {
      enable = mkEnableOption "Enables fail2ban, enables all jails defined in services";
      virtualHosts = mkOption {
        default = {};
        description = "The port to listen on";
      };
      usesKeyDeploy = mkOption {
        default = false;
      };
    };
  };

  config = mkIf cfg.enable {
    services.nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";
      virtualHosts = cfg.virtualHosts;
    };
    users.users."nginx".extraGroups = mkIf cfg.usesKeyDeploy [ "keys" ];
    services.fail2ban.jails = mkIf config.roxie.services.fail2ban.enable {
      nginx-http-auth = ''
        enabled  = true
        filter   = nginx-http-auth
        banaction = iptables-allports
        logpath  = /var/log/nginx/error.log
        bantime  = 1800
        maxretry = 5
      '';
      nginx-badbots = ''
        enabled  = true
        port     = http,https
        filter   = apache-badbots
        logpath  = /var/log/nginx/access.log
        maxretry = 2
        bantime  = -1
      '';
    };
  };
}