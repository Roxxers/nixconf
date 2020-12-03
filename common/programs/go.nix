{ config, lib, pkgs, ... }: {
  options = {
    roxie.go.enable = lib.mkEnableOption "Installs go packages";
  };

  config = lib.mkIf config.roxie.go.enable {
    environment.systemPackages = with pkgs; [
      go
      go-tools
    ];
  };
}