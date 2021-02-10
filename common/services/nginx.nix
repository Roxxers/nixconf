{ config, lib, pkgs, ... }: 
let cfg = config.roxie.services.nginx;
in with lib; {
  options = {
    roxie.services.nginx = {
      enable = mkEnableOption "Nginx";
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
      logError = "/var/log/nginx/error.log";
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";
      virtualHosts = cfg.virtualHosts;
    };
    users.users."nginx".extraGroups = mkIf cfg.usesKeyDeploy [ "keys" ];
    services.fail2ban.jails = mkIf config.services.fail2ban.enable {
      nginx-http-auth = ''
        enabled  = true
        port     = http,https
        filter   = nginx-http-auth
        logpath  = /var/log/nginx/error.log
        backend = polling
        banaction = iptables-allports
        findtime = 1800
        bantime  = 1800
        maxretry = 5
      '';
      nginx-badbots = ''
        enabled  = true
        port     = http,https
        filter   = apache-badbots
        logpath  = /var/log/nginx/access.log
        backend = polling
        maxretry = 2
        bantime  = -1
      '';
    };
  };
}