{ config, lib, pkgs, ... }: {
  options = {
    roxie.programs.qemu.enable = lib.mkEnableOption "Installs VM stuff";
  };

  config = lib.mkIf config.roxie.programs.qemu.enable {
    virtualisation.libvirtd.enable = true;
    programs.dconf.enable = true;
    environment.systemPackages = with pkgs; [ virt-manager ];
  };
}