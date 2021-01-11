{ config, lib, pkgs, ... }: {
  options = {
    roxie.programs.go.enable = lib.mkEnableOption "Installs go packages";
  };

  config = lib.mkIf config.roxie.programs.go.enable {
    environment.systemPackages = with pkgs; [
      go
      go-tools
    ];
  };
}