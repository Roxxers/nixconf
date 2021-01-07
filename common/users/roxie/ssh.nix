{ pkgs, lib, ... }:

{
  programs.ssh = 
  let
  user = "roxie";
  home = "/home/${user}";
  defaultKey = "${home}/.ssh/id_rsa";
  aurKey = "${home}/.ssh/aur";

  in
  {
    enable = true;
    matchBlocks = {
      # Personal Intranet
      "pihole" = {
        hostname = "192.168.0.2";
        identityFile = [ defaultKey ];
        port = 22;
        user = user;
      };
      "laser-moon" = {
        host = "desktop";
        hostname = "192.168.0.10";
        identityFile = [ defaultKey ];
        port = 22;
        user = user;
      };
      "lesbos" = {
        host = "lesbos";
        hostname = "192.168.0.4";
        identityFile = [ defaultKey ];
        port = 22;
        user = user;
      };
      # Utility Servers
      "scarif-1" = {
        host = "scarif-1";
        hostname = "u218033.your-storagebox.de";
        identityFile = [ defaultKey ];
        port = 22;
        user = "u218033";
      };
      # Personal Misc
      "tilde.town" = {
        host = "tilde tilde.town";
        hostname = "tilde.town";
        identityFile = [ defaultKey ];
        port = 22;
        user = "roxie_";
      };
      "aur" = {
        host = "aur";
        hostname = "aur.archlinux.org";
        identityFile = [ aurKey ];
        port = 22;
        user = "aur";
      };
      # Work
      "caat" = {
        host = "caat.org.uk";
        hostname = "caat.org.uk";
        identityFile = [ defaultKey ];
        port = 24354;
        user = user;
      };
    };
  };
}
