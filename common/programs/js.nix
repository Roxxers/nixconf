# JS, Node.js, Typescript all in one

{ config, lib, pkgs, ... }: {
  options = {
    roxie.programs.node.enable = lib.mkEnableOption "Installs python packages";
  };

  config = lib.mkIf config.roxie.programs.node.enable {
    environment.systemPackages = with pkgs; [
      nodejs
      nodePackages.yarn
      nodePackages.typescript
    ];
  };
}