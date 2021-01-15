
{ config, lib, pkgs, ... }:

{
  imports = [
    ./desktop
    ./programs
    ./networking
    ./services
    ./users
    ./ssd.nix
  ];
  nix = {
    trustedUsers = [ "root" "roxie" ];
    autoOptimiseStore = true;
  };
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };
}