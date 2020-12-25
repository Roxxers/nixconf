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
];
wireguard_ip = "10.0.0.2";
lan_ip = "192.168.0.4";
in

{ config, pkgs, ... }:

{
  inherit imports;
  system.stateVersion = "20.09";

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
        # { # pixel
        #   publicKey = "X9dKW80aJ6igJDQf8cS5mvYEPXTvtmbTPpLMg5xIGjM=";
        #   allowedIPs = [ "10.0.0.11/32" ];
        #   presharedKeyFile = "/run/keys/wgpsk_lesbos_pixel";
        #   endpoint = "192.168.0.11:42783";
        # }
        { # laser-moon
          publicKey = "L5CcXiZ3+cWq5BlZm1M3FygyOoIgMJOYQNVzkO7u8Bc=";
          allowedIPs = [ "10.0.0.10/32" ];
          presharedKeyFile = "/run/keys/wgpsk_lesbos_laser-moon";
          endpoint = "192.168.0.10:1114";
        }
      ];
    };
    tor.enable = true;
    qemu.enable = true;
  };

  deployment.keys = {
    wgpsk_lesbos_laser-moon = {
      text = builtins.readFile ../../secrets/psks/lesbos_laser-moon.psk;
    };
    wgpsk_lesbos_pixel = {
      text = builtins.readFile ../../secrets/psks/lesbos_pixel.psk;
    };
    wgpsk_lesbos_subspace = {
      text = builtins.readFile ../../secrets/psks/lesbos_subspace.psk;
    };
    wg_private = {
      text = builtins.readFile ../../secrets/lesbos/wg_priv;
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
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
}

