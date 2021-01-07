{ pkgs, lib, ... }:

{
  imports = [
    ./colorls
    ./neofetch
    ./ssh.nix
    ./zsh
    # Comment out below lines if system is headless or desktop
    ./kitty.nix
    ./firefox.nix
    ./git # Git and gpg here to avoid bad practices with doing this stuff on servers
    ./gpg.nix
    ./keychain.nix
    ./mpd.nix
    ./vscode
  ];

  programs.home-manager = {
    enable = true;
    path = "…";
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };
}
