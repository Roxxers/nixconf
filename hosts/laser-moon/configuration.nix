let 
nixConf = "/home/roxie/.config/nixpkgs/";
machine = "${nixConf}/hosts/laser-moon";
imports = [
  (/. + "${nixConf}/common/")
  (/. + "${machine}/hardware-configuration.nix")
  (/. + "${machine}/backups.nix")

  # For home-manager
  #(/. + "${nixConf}/common/users/home-manager.nix")
];

in

{ config, pkgs, ... }:

{
  nixpkgs.config.permittedInsecurePackages = [
    "python2.7-cryptography-2.9.2"
  ];
  inherit imports;
  system.stateVersion = "20.09";

  roxie = {
    ssd.enable = true;
    sshd.enable = true;
    tor.enable = true;
    tor.browserEnable = true;
    desktop = {
      enable = true;
      plasma.enable = true;
      gaming.enable = true;
    };
    go.enable = true;
    node.enable = true;
    python.enable = true;
    lanPrinter.enable = true;
    lesbosMounts.enable = true;
    qemu.enable = true;
  };

  # Networking
  networking.hostName = "laser-moon";
  networking.useDHCP = false;
  networking.interfaces.enp10s0.useDHCP = true;
  # Wireguard subspace network
  roxie.subspace = {
    enable = true;
    ips = [ "10.0.0.10/21" ];
    listenPort = 1114;
    privateKeyFile = "/root/wg/private";
    subspacePresharedKeyFile = "/root/wg/laser-moon_subspace.psk";
    extraPeers = [
      # {
      #   publicKey = "X9dKW80aJ6igJDQf8cS5mvYEPXTvtmbTPpLMg5xIGjM=";
      #   allowedIPs = [ "10.0.0.11/32" ];
      #   presharedKeyFile = "/root/wg/pixel_laser-moon.psk";
      # }
      { # lesbos
        publicKey = "3G2ek0EbYBpn82Gvk5QU9qaqKTrA2QgtPSL1YgCX7Rw=";
        presharedKeyFile = "/root/wg/lesbos_laser-moon.psk";
        allowedIPs = [ "10.0.0.2/32" ];
        endpoint = "192.168.0.4:51121";
      }
    ];
  };

  services.nginx = {
    enable = true;
    virtualHosts.example = {
      locations."/" = {
        root = "${config.system.build.manual.manualHTML}/share/doc/nixos";
      };
    };
  };

  # BOOT
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # grub
  boot.loader.grub = {
    enable = true;
    version = 2;
    efiSupport = true;
    enableCryptodisk = true;
    device = "nodev";
  };
  # Secrets for non-root
  boot.initrd.secrets = {
    "keyfile0.bin" = "/etc/secrets/initrd/keyfile0.bin";
    "hdd.bin" = "/etc/secrets/initrd/hdd.bin";
  };
  # luks
  boot.initrd.luks.devices = {
    encRoot = {
      device = "/dev/disk/by-uuid/c36765a0-3541-4e52-b4c5-c565a386f33f";
      preLVM = true;
    };
  };
  # ssd for games
  fileSystems."/mnt/ssd" = {
    device = "/dev/disk/by-uuid/1704f140-d162-4799-a0dd-436506ea6ae0"; # UUID for /dev/mapper/crypted-data
    encrypted = {
      enable = true;
      label = "ssd";
      blkDev = "/dev/disk/by-uuid/2b0c77ae-7aed-4cd7-87e0-1b5ead5e7de5"; # UUID for /dev/sda1
      keyFile = "/keyfile0.bin";
    };
  };
  fileSystems."/mnt/hdd" = {
    device = "/dev/disk/by-uuid/ef659b98-c84c-4261-96ce-f15c75af1215"; # UUID for /dev/mapper/crypted-data
    encrypted = {
      enable = true;
      label = "hdd";
      blkDev = "/dev/disk/by-uuid/79a168ce-c974-43f4-881c-e0c3b5ffe95f"; # UUID for /dev/sda1
      keyFile = "/hdd.bin";
    };
  };
  boot.kernelParams = [ "amd_iomu=soft" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
  services.xserver.videoDrivers = [ "nvidia" ];
}

