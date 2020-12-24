let 
nixConf = "/home/roxie/.config/nixpkgs/";
machine = "${nixConf}/hosts/subspace";
imports = [
  (/. + "${nixConf}/common")

  # Machine specific setup
  (/. + "${machine}/hardware-configuration.nix")
  (/. + "${machine}/wireguard_server.nix")
  (/. + "${machine}/nginx.nix")
];
wireguard_ip = "10.0.3.1";
in
{ config, pkgs, resources, ... }:

{
  nixpkgs.config.permittedInsecurePackages = [
    "python2.7-cryptography-2.9.2"
  ];
  inherit imports;
  
  networking.hostName = "subspace";
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "20.09";
  networking.useDHCP = true;

  roxie = {
    sshd = {
      enable = true;
      tor.enable = true;
      endlessh.enable = true;
      permitRoot = true;
      wgSupport = {
        enable = true;
        ip = wireguard_ip; 
      };
    };
    tor.enable = true;
    # python.enable = true;
  };

  deployment.keys = {
    wgpsk_laser-moon_subspace = {
      text = builtins.readFile ../../secrets/psks/laser-moon_subspace.psk;
    };
    wgpsk_pixel_subspace = {
      text = builtins.readFile ../../secrets/psks/pixel_subspace.psk;
    };
    wgpsk_lesbos_subspace = {
      text = builtins.readFile ../../secrets/psks/lesbos_subspace.psk;
    };
    wg_private = {
      text = builtins.readFile ../../secrets/subspace/wg_private;
    };
  };

  # BOOT
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "nodev"; # or "nodev" for efi only
  boot.loader.grub.copyKernels = true;
  boot.loader.grub.fsIdentifier = "label";
  boot.loader.grub.extraConfig = "serial; terminal_input serial; terminal_output serial";
  boot.kernelParams = [ "console=ttyS0" ];  
}

