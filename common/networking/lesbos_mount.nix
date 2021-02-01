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
    fileSystems."/mnt/books" = {
      device = "192.168.0.4:/srv/books";
      fsType = "nfs";
    };
    fileSystems."/mnt/music" = {
      device = "192.168.0.4:/srv/music";
      fsType = "nfs";
    };
    fileSystems."/mnt/pictures" = {
      device = "192.168.0.4:/srv/pictures";
      fsType = "nfs";
    };
    fileSystems."/mnt/videos" = {
      device = "192.168.0.4:/srv/videos";
      fsType = "nfs";
    };
  };
}