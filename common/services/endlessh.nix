{ config, lib, pkgs, ... }:
with lib; {
  options.custom.services.endlessh = {
    enable = mkEnableOption "Enables endlessh service";
    port = mkOption {
      type = types.port;
      default = 22;
      description = "The port to listen on";
    };
  };
  config = mkIf config.custom.services.endlessh.enable {
    environment.systemPackages = with pkgs; [ endlessh ];
    # Just copied unit from the repo into nix version
    systemd.services.endlessh = {
      description = "Endlessh SSH Tarpit";
      documentation = ["man:endlessh(1)"];
      requires = [ "network-online.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.endlessh}/bin/endlessh";
        KillSignal = "SIGTERM";
        Restart = "always";
        RestartSec = "30sec";
        StartLimitBurst = 4;
        StandardOutput = "journal";
        StandardError = "journal";
        StandardInput = null;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectSystem = "full";
        ProtectHome = true;
        InaccessiblePaths = "/run /var";
        AmbientCapabilities="CAP_NET_BIND_SERVICE";
        NoNewPrivileges = true;
        ConfigurationDirectory = "endlessh";
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        MemoryDenyWriteExecute = true;

      };
      startLimitIntervalSec = 300;
      wantedBy = [ "multi-user.target" ];
    };

    # Write endlessh config file to run on default ssh port
    environment.etc."endlessh/config" = {
      text = "Port ${toString config.custom.services.endlessh.port}\nLogLevel 1\n";
    };

    # Enable service
    systemd.services.endlessh.enable = true;
  };

}
