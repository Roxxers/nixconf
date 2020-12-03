{ pkgs, lib, ... }:

{
  # If you get read-only errors from this config, use 'touch ~/.gitconfig' as this stops these errors as it has a config it can lock
  programs.git = {
    enable = true;
    userName = "Roxie Gibson";
    userEmail = "me@roxxers.xyz";
    includes = [
      { path = "./aliases"; }
    ];
    signing = {
      key = "49B0A560F2C05D0A4460B6935D0140EDEE123F4D";
      signByDefault = true;
    };
    extraConfig = {
      commit = { template = "/home/roxie/.config/git/template/commit"; };
      tag = { forceSignAnnotated = true; }; # Force signing tags
      init = { templateDir = "/home/roxie/.config/git/template/init"; };
    };
  };
  home.packages = with pkgs; [
    gitAndTools.gitstatus
  ];
  home.file = {
    aliases = {
      source = ./aliases;
      target = ".config/git/aliases";

    };
    templates = {
      source = ./template;
      target = ".config/git/template";
    };
  };
}