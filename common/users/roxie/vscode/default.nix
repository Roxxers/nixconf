{ pkgs, lib, config, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
  };
  home.file.settings = {
    source = ./settings.json;
    target = ".config/VSCodium/User/settings.json";
  };
}