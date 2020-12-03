
{ config, lib, pkgs, ... }:

{
  imports = [ ./lan_printer.nix ./lesbos_mount.nix ./wireguard_client.nix ];
}