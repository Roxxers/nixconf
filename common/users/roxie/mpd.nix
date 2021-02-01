{ pkg, lib, ... }:

{
  services.mpd = {
    enable = true;
    musicDirectory = "/mnt/music/The Collection/";
    extraConfig = ''
      audio_output {
        type "pulse" # MPD must use Pulseaudio
        name "Pulseaudio" # Whatever you want
        server "127.0.0.1" # MPD must connect to the local sound server
      }
    '';
  };

  programs.ncmpcpp.enable = true;

  services.mpdris2 = {
    enable = true;
    notifications = true;
  };
}