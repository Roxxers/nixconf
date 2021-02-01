let 
nixConf = "/home/roxie/.config/nixpkgs/";
machine = "${nixConf}/hosts/lesbos";
imports = [
  (/. + "${nixConf}/common")

  # Machine specific setup
  (/. + "${machine}/hardware-configuration.nix")
  (/. + "${machine}/jellyfin.nix")
  (/. + "${machine}/mounts.nix")
  (/. + "${machine}/nextcloud.nix")
  (/. + "${machine}/backups.nix")
  #(/. + "${machine}/hass.nix")
];
wireguard_ip = "10.0.0.2";
lan_ip = "192.168.0.4";
in

{ config, pkgs, ... }:

{

  inherit imports;
  system.stateVersion = "20.09";

  networking.firewall = {
    allowedTCPPorts = [ 80 443 ];
  };

  services.nginx.enable = true;
  roxie = {
    sshd = {
      enable = true;
      tor.enable = true;
      endlessh.enable = true;
      permitRoot = true;
    };
    subspace = {
      enable = true;
      ips = [ "10.0.0.2/21" ];
      listenPort = 51121;
      privateKeyFile = "/run/keys/wg_private";
      subspacePresharedKeyFile = "/run/keys/wgpsk_lesbos_subspace";
      extraPeers = [
        { # laser-moon
          publicKey = "L5CcXiZ3+cWq5BlZm1M3FygyOoIgMJOYQNVzkO7u8Bc=";
          allowedIPs = [ "10.0.0.10/32" ];
          presharedKeyFile = "/run/keys/wgpsk_lesbos_laser-moon";
          endpoint = "192.168.0.10:1114";
        }
        { # pihole
          publicKey = "ILsheX2HYfqtRnu2qOoW88vN3oHtRhzFl4LvGk3eUhM=";
          presharedKeyFile = "/run/keys/wgpsk_pihole_lesbos";
          allowedIPs = [ "10.0.0.1/32" ];
          endpoint = "192.168.0.2:52000";
        }
      ];
    };
    tor.enable = true;
    programs.qemu.enable = true;
  };

  deployment.keys = {
    wgpsk_lesbos_laser-moon = {
      text = builtins.readFile ../../secrets/psks/lesbos_laser-moon.psk;
    };
    wgpsk_lesbos_subspace = {
      text = builtins.readFile ../../secrets/psks/lesbos_subspace.psk;
    };
    wgpsk_pihole_lesbos = {
      text = builtins.readFile ../../secrets/psks/pihole_lesbos.psk;
    };
    wg_private = {
      text = builtins.readFile ../../secrets/lesbos/wg_priv;
    };
    sslCert = {
      text = builtins.readFile ../../secrets/lesbos/jelly-cloud-stash-photos/cert.pem;
      user = "nginx";
      group = "nginx";
    };
    sslKey = {
      text = builtins.readFile ../../secrets/lesbos/jelly-cloud-stash-photos/key.pem;
      user = "nginx";
      group = "nginx";
    };
    mediabackup = {
      text = builtins.readFile ../../secrets/lesbos/mediabackup;
    };
  };

  # Networking
  networking.hostName = "lesbos";
  networking.useDHCP = false;
  networking.interfaces.enp37s0.useDHCP = true;

  # BOOT
  boot.loader.grub = {
    enable = true;
    version = 2;
    efiSupport = true;
    device = "nodev";
  };
  boot.loader.grub.copyKernels = true; # https://nixos.wiki/wiki/NixOS_on_ZFS#Known_issues
  boot.supportedFilesystems = [ "zfs" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ zfs ];
  services.zfs.autoSnapshot.enable = true;
  services.zfs.autoScrub.enable = true;
  networking.hostId = "36f5c448";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
}

