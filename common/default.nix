
{ config, lib, pkgs, ... }:

{
  imports = [
    ./desktop
    ./programs
    ./networking
    ./services
    ./users
    ./ssd.nix
    ./ssh.nix
    ./tor.nix
  ];
  nix = {
    trustedUsers = [ "root" "roxie" ];
    autoOptimiseStore = true;
  };
}