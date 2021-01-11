{ config, lib, pkgs, ... }: {
  options = {
    roxie.programs.docker.enable = lib.mkEnableOption "Enable docker and install docker tools";
  };

  config = lib.mkIf config.roxie.programs.docker.enable {
    virtualisation.docker = {
      enable = true;
    };
    environment.systemPackages = with pkgs; [
      docker-compose
      lazydocker
    ];
  };
}