{ config, lib, pkgs, ... }: {
  options = {
    roxie.python.enable = lib.mkEnableOption "Installs python packages";
  };

  config = lib.mkIf config.roxie.python.enable {
    environment.systemPackages = with pkgs; [
      gcc # Compiling python libs
      python39Full
      python39Packages.pip
      pipenv
      python39Packages.virtualenvwrapper
    ];
  };
}