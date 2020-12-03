# Mounting for my network drives on lesbos
# Should use wireguard when setup

{ config, lib, pkgs, ... }: 
let cfg = config.roxie.lesbosMounts;
in with lib;
{
  options = {
    roxie.lesbosMounts.enable = mkEnableOption "Mounts lesbos network drives";
  };

  config = mkIf cfg.enable {
    fileSystems."/mnt/storage2" = {
      device = "192.168.0.4:/srv/nfs/media";
      fsType = "nfs";
    };
    fileSystems."/mnt/storage3" = {
      device = "192.168.0.4:/srv/nfs/dump";
      fsType = "nfs";
    };
  };
}