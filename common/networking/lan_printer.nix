
{ config, lib, pkgs, ... }: 
let cfg = config.roxie.lanPrinter;
in with lib;
{
  options = {
    roxie.lanPrinter.enable = mkEnableOption "Mounts lesbos network drives";
  };

  config = mkIf cfg.enable {
    services.printing.enable = true;
    services.printing.drivers = [ pkgs.hplip ];
  };
}