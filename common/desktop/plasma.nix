{ config, lib, pkgs, ... }: 
let cfg = config.roxie.desktop.plasma; kdeConnectPorts = { from = 1714; to = 1764; };
in with lib; {

  options.roxie.desktop.plasma.enable = mkEnableOption "Enable plasma desktop and kde applications";

  config = mkIf cfg.enable {
    # Enable the Plasma 5 Desktop Environment.
    
    services.xserver.displayManager.sddm.enable = true;
    services.xserver.desktopManager.plasma5.enable = true;
    nixpkgs.config.firefox.enablePlasmaBrowserIntegration = true;

    environment.systemPackages = with pkgs; [
      kdeApplications.ark
      kdeApplications.dolphin-plugins
      kdeApplications.filelight
      kdeApplications.gwenview
      kdeApplications.kate
      kdeApplications.kcalc
      kdeApplications.kdeconnect-kde
      kdeApplications.kdf
      kdeApplications.kgpg
      kdeApplications.kontact
      kdeApplications.okular
      kdeApplications.ffmpegthumbs

      konversation
      plasma5.discover
      plasma5.kdeplasma-addons
      plasma5.kscreenlocker
      plasma5.ksshaskpass
      plasma5.plasma-nm
      #plasma5.user-manager
      plasma-browser-integration

      kwalletcli
      pinentry-qt
    ];
    # Open kdeConnect ports
    networking.firewall.allowedTCPPortRanges = [
      kdeConnectPorts
    ];
    networking.firewall.allowedUDPPortRanges = [
      kdeConnectPorts
    ];
  };
}
