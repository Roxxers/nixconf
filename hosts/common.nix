# Common configs for all machines which don't belong in the normal files
# but are too generic for the per-machine config

{ config, pkgs, ... }:

{
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "uk";
  };
}