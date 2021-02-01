
{ config, lib, pkgs, ... }:
let cfg = config.roxie.services.bitwarden;
in with lib; {
  options = {
    roxie.services.bitwarden = {
      enable = mkEnableOption "Enables bitwarden_rs server";
      adminTokenFile = mkOption {
        type = types.path;
      };
    };
  };

  config = mkIf config.roxie.services.bitwarden.enable {
    services.bitwarden_rs = {
      enable = true;
      #backupDir = "/etc/bitwarden";
      config = {
        WEB_VAULT_FOLDER = "${pkgs.bitwarden_rs-vault}/share/bitwarden_rs/vault";
        WEB_VAULT_ENABLED = true;
        LOG_FILE = "/var/log/bitwarden/log";
        LOG_LEVEL = "Info";
        EXTENDED_LOGGING = true;
        DATA_FOLDER = "/var/lib/bitwarden_rs";

        INVITATIONS_ALLOWED = false;
        SIGNUPS_VERIFY = false;

        WEBSOCKET_ENABLED = true;
        WEBSOCKET_ADDRESS = "0.0.0.0";
        WEBSOCKET_PORT = 3012;

        ADMIN_TOKEN = builtins.readFile cfg.adminTokenFile;
        domain = "https://bitwarden.awoo";
        ROCKET_PORT = 8812;
      };
    };
    environment.systemPackages = with pkgs; [
      bitwarden_rs-vault
    ];
    environment.etc."fail2ban/filter.d/bitwarden_rs.conf" = {
      text = ''
        [INCLUDES]
        before = common.conf

        [Definition]
        failregex = ^.*Username or password is incorrect\. Try again\. IP: <ADDR>\. Username:.*$
        ignoreregex =
      '';
    };
    services.fail2ban.jails.bitwarden_rs = mkIf config.roxie.services.fail2ban.enable ''
      enabled  = true
      filter   = bitwarden_rs
      findtime = 600
      bantime  = 600
      maxretry = 3
    '';
  };
}