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
  networking.nameservers = [ "10.0.0.1" "9.9.9.9" ];
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

  # BOOT
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "nodev"; # or "nodev" for efi only
  boot.loader.grub.copyKernels = true;
  boot.loader.grub.fsIdentifier = "label";
  boot.loader.grub.extraConfig = "serial; terminal_input serial; terminal_output serial";
  boot.kernelParams = [ "console=ttyS0" ];  
}

