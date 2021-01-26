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
      libsForQt5.ark
      libsForQt5.dolphin-plugins
      libsForQt5.filelight
      libsForQt5.gwenview
      libsForQt5.kate
      libsForQt5.kcalc
      libsForQt5.kdeconnect-kde
      libsForQt5.kdf
      libsForQt5.kgpg
      libsForQt5.kontact
      libsForQt5.okular
      libsForQt5.ffmpegthumbs

      konversation
      libsForQt5.discover
      libsForQt5.kdeplasma-addons
      libsForQt5.kscreenlocker
      libsForQt5.ksshaskpass
      libsForQt5.plasma-nm
      plasma-browser-integration

      kwalletcli
      pinentry-qt
    ];

    # compositor
    # setup so no tearing on nvidia non-free drivers
    services.picom = {
      enable = true;
      vSync = true;
      fade = true;
      fadeDelta = 5;
      fadeSteps = [ 0.04 0.04 ];
      backend = "xr_glx_hybrid";
      settings = {
        xrender-sync-fence = true;
      };
    };

    # Open kdeConnect ports
    networking.firewall.allowedTCPPortRanges = [
      kdeConnectPorts
    ];
    networking.firewall.allowedUDPPortRanges = [
      kdeConnectPorts
    ];
  };
}
