{ config, lib, pkgs, ... }: 
let cfg = config.roxie.services.fail2ban;
in with lib; {
  options = {
    roxie.services.fail2ban.enable = mkEnableOption "Enables fail2ban, enables all jails defined in services";
  };

  config = mkIf cfg.enable {
    services.fail2ban.enable = true;
  };
}