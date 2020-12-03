{ pkgs, lib, ... }:

{
  home.file.colorlsConf = {
    source = ./dark_colors.yaml;
    target = ".config/colorls/dark_colors.yaml";
  };
}