{ pkg, lib, ... }:

{
  home.file = {
    neofetchConf = {
      executable = false;
      source = ./config.conf;
      target = ".config/neofetch/config.conf";
    };
  };
}