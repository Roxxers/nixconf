
{ config, lib, pkgs, ... }: {
  options = {
    roxie.tor.enable = lib.mkEnableOption "Enables tor client programs";
    roxie.tor.browserEnable = lib.mkEnableOption "Enables tor browser";
  };

  config = lib.mkIf config.roxie.tor.enable {
    services.tor.enable = true;
    services.tor.client.enable = true;
    environment.systemPackages = lib.mkIf config.roxie.tor.browserEnable [ pkgs.torbrowser ];
  };
}