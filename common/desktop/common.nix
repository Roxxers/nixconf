{ config, lib, pkgs, ... }: 
let cfg = config.roxie.desktop; kdeConnectPorts = { from = 1714; to = 1764; };
in with lib; {

  options.roxie.desktop.enable = mkEnableOption "Enable generic desktop settings";

  config = mkIf cfg.enable {
    services.xserver.enable = true;
    services.xserver.layout = "gb";
    # Enable sound.
    sound.enable = true;
    hardware.pulseaudio = {
      enable = true;
      extraConfig = "load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1"; # Needed by mpd to be able to use Pulseaudio

      # NixOS allows either a lightweight build (default) or full build of PulseAudio to be installed.
      # Only the full build has Bluetooth support, so it must be selected here.
      package = pkgs.pulseaudioFull;
    };
    hardware.bluetooth.enable = true;

    # Networking
    networking.networkmanager = {
      enable = true;
      packages = with pkgs; [ networkmanager-openvpn ];
    };

    nixpkgs.overlays = [
      (
        self: super: {
          libbluray = super.libbluray.override {
            withAACS = true;
            withBDplus = true;
          };
        }
      )
    ];

    services.flatpak.enable = true;
    environment.systemPackages = with pkgs; [
      # Useful desktop apps
      simple-scan # even if gtk3, basically the only photoscanner app I like
      ffmpegthumbnailer
      pavucontrol
      # Internet
      deluge
      wasabiwallet
      # Browsers
      chromium
      firefox
      # Chatting
      discord 
      element-desktop
      mumble
      signal-desktop 
      # Multimedia
      cantata
      streamlink
      vlc
      # Productive
      gimp # Waiting for glimpse to be added to nixpkgs
      gtimelog
      inkscape
      libreoffice-fresh
      thunderbird
      vscodium
      virt-manager
      # Theming
      dracula-theme # this should have many different configs for different programs
      libsForQt5.qtstyleplugin-kvantum
      flat-remix-icon-theme
    ];

    fonts = {
      # Find the name of your fonts
      # under /run/current-system/sw/share/X11-fonts
      fonts = with pkgs; [
        font-awesome
        twemoji-color-font
        inconsolata
        fira-code
        hack-font
        mononoki
        noto-fonts
        roboto
        ubuntu_font_family
        nerdfonts
      ];
      fontconfig = {
        enable = true;
        antialias = true;
      };
    };
  };
}
