{ pkgs, lib, ... }:

{
  imports = [
    ./home/colorls
    ./home/neofetch
    ./home/ssh
    ./home/zsh
    # Comment out below lines if system is headless or desktop
    ./home/kitty
    ./home/firefox
    ./home/git # Git and gpg here to avoid bad practices with doing this stuff on servers
    ./home/gpg
    ./home/keychain
    ./home/mpd
    ./home/vscode
  ];

  programs.home-manager = {
    enable = true;
    path = "…";
  };
  
}
