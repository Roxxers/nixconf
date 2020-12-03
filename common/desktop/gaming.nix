{ config, lib, pkgs, ... }: 
let cfg = config.roxie.desktop.gaming;
in with lib; {

  options.roxie.desktop.gaming.enable = mkEnableOption "Installs Steam, Minecraft, itch.io, lutris, and any supporting settings and packages";

  config = mkIf cfg.enable {
    # Steam
    programs.steam.enable = true;
    # Steam support with 32bit support
    hardware.opengl.driSupport32Bit = true;
    hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
    hardware.pulseaudio.support32Bit = true;

    environment.systemPackages = with pkgs; [
      minecraft
      
      # Lutris and wine support
      wineWowPackages.staging
      winetricks
      protontricks
      lutris
      vulkan-tools
      vulkan-loader
      vulkan-headers
      libxkbcommon
      mesa
      wayland
    ];
  };
}
