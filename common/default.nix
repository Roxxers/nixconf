
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
}