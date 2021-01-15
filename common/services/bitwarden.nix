
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

  config = lib.mkIf config.roxie.services.bitwarden.enable {
    networking.firewall.allowedTCPPorts = [
      8812 8000
    ];
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

  };
}