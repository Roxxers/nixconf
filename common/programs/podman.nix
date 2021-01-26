{ config, lib, pkgs, ... }: {
  options = {
    roxie.programs.podman.enable = lib.mkEnableOption "Enable podman and install podman tools";
  };

  config = lib.mkIf config.roxie.programs.podman.enable {
    virtualisation.podman = {
      enable = true;
    };
    environment.systemPackages = with pkgs; [
      podman-compose
    ];
    virtualisation.oci-containers.backend = "podman";
  };
}