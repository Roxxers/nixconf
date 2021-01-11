{ config, lib, pkgs, ... }: {
  options = {
    roxie.programs.tomb.enable = lib.mkEnableOption "Installs Tomb and supporting packages";
  };

  config = lib.mkIf config.roxie.programs.tomb.enable {
    environment.systemPackages = with pkgs; [
      dcfldd
      gettext
      lsof
      steghide
      qrencode
      tomb
      unoconv
    ];
  };
}