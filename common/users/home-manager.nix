{ config, lib, pkgs, ... }: 
{
  # imports = [ <home-manager/nixos> ];
  home-manager.users.roxie = (import ./roxie/home.nix); 
}