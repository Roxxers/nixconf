{ config, pkgs, lib, ... }:

{
  imports = [ ./go.nix ./js.nix ./python.nix ./tomb.nix ./virtualisation.nix ];
  # Install all basic programs that I need in my servers and desktops
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # Installed for the terminfo file. home-manager deals with actual kitty term config
    kitty
    # Compression
    lz4
    p7zip
    unrar

    # System tools
    bat
    colorls
    ffmpeg-full
    git
    gnupg
    gopass
    handbrake
    htop
    mkcert
    ncdu
    neofetch
    openssl
    pinentry
    pinentry-curses
    pwgen-secure
    qrencode
    rclone
    rsync
    screen
    sshfs
    tomb
    trash-cli
    vim
    wget
    youtube-dl

    # Tomb util packages


    # Stuff that needs to be moved to different files
    docker-compose
    home-manager
    #nixops
  ];

  # Some default ssh client configs
  programs.ssh = {
    kexAlgorithms = [ "curve25519-sha256@libssh.org" "diffie-hellman-group-exchange-sha256" ];
    hostKeyAlgorithms = [ "ssh-ed25519-cert-v01@openssh.com" "ssh-rsa-cert-v01@openssh.com" "ssh-ed25519" "ssh-rsa" ];
    ciphers = [ "chacha20-poly1305@openssh.com" "aes256-gcm@openssh.com" "aes128-gcm@openssh.com" "aes256-ctr" "aes192-ctr" "aes128-ctr" ];
    macs = [ "hmac-sha2-512-etm@openssh.com" "hmac-sha2-256-etm@openssh.com" "umac-128-etm@openssh.com" "hmac-sha2-512" "hmac-sha2-256" "umac-128@openssh.com" ];
    extraConfig = "UseRoaming no\nHashKnownHosts yes";
  };
}
