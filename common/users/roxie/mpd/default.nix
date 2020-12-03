{ pkg, lib, ... }:

{
  services.mpd = {
    enable = true;
    musicDirectory = /home/roxie/Music;
  };

  services.mpdris2 = {
    enable = true;
    notifications = true;
  };
}