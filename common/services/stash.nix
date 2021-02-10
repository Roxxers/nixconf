{ config, lib, pkgs, ... }:
let cfg = config.roxie.services.stash;
localPkgs = import ../pkgs/default.nix { pkgs = pkgs; };
in with lib; {
  options.roxie.services.stash = {
    enable = mkEnableOption "Enables stash service";
    listenAddr = mkOption {
      type = types.str;
      default = "0.0.0.0";
    };
    port = mkOption {
      type = types.port;
      default = 9999;
      description = "The port to listen on";
    };
  };
  config = mkIf cfg.enable {
    users.users.stash = {
      isSystemUser = true;
      home = "/var/lib/stash";
      createHome = true;
    };
    environment.systemPackages = [ localPkgs.stash ];
    # Just copied unit from the repo into nix version
    systemd.services.stash = {
      serviceConfig = {
        Type = "simple";
        ExecStart = "${localPkgs.stash}/bin/stash -c /root/.stash/config.yml --host ${cfg.listenAddr} --port ${toString cfg.port}";
        #User = "stash";
        KillSignal = "SIGTERM";
        Restart = "always";
        RestartSec = "30sec";
        StartLimitBurst = 4;
        StandardOutput = "journal";
        StandardError = "journal";
        StandardInput = null;
      };
      startLimitIntervalSec = 60;
      wantedBy = [ "multi-user.target" ];
    };


    # Enable service
    systemd.services.stash.enable = true;
  };

}
