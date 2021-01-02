{ config, lib, pkgs, ... }: 
with lib; 
{
  users.users.roxie = {
    isNormalUser = true;
    home = "/home/roxie";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "docker" "roxie" "libvirtd" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPQUgoeTXvokZ3QGFkp8dRXcMK1AHCPPKf0tij149pua roxie@laser-moon"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAF94sbl8Og0t24HCJoKmLXtk0bfr4jii0WSmkhEqtVa roxie@lava-world"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC+1nj0R3rEHS5I4JViPupThEg5kdMPYddk8CE0t/xVV roxie@forest"
    ];
  };

  # imports = if config.roxie.desktop.enable then [ ./home-manager.nix ] else [];
}