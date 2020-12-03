{ config, lib, ... }: 
let cfg = config.roxie.sshd;
in with lib; {
  imports = [ ./services ]; 
  options.roxie.sshd = {
    enable = mkEnableOption "Enables ssh daemon";
    port = mkOption {
      type = types.port;
      default = 2222;
      description = "The port to listen on";
    };
    tor.enable = mkEnableOption "Enables tor endpoint for ssh daemon";
    endlessh = {
      enable = mkEnableOption "Enables endlessh service";
      port = mkOption {
        type = types.port;
        default = 22;
        description = "The port to listen on";
      };
    };
    wgSupport = {
      enable = mkEnableOption "Enables support for subspace wireguard network and limits listening to wireguard and tor";
      ip = mkOption {
        type = types.str;
        description = "IP of this client within the subspace wireguard network";
      };
    };
    permitRoot = mkOption {
      type = types.bool;
      default = false;
      description = "Enable root login for nixops servers";
    };

  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      ports = [ cfg.port ];
      openFirewall = true;
      logLevel = "VERBOSE";
      permitRootLogin = if cfg.permitRoot then "yes" else "no";
      passwordAuthentication = false;
      challengeResponseAuthentication = false;
      macs = [ "hmac-sha2-512-etm@openssh.com" "hmac-sha2-256-etm@openssh.com" "umac-128-etm@openssh.com" ];
      kexAlgorithms = [ "curve25519-sha256@libssh.org" "diffie-hellman-group16-sha512" "diffie-hellman-group18-sha512" "diffie-hellman-group14-sha256" ];
      extraConfig = ''
PubkeyAuthentication yes
AuthenticationMethods publickey
UsePAM yes
Protocol 2
ClientAliveInterval 300
ClientAliveCountMax 2'';
      listenAddresses = mkIf cfg.wgSupport.enable [ { addr = cfg.wgSupport.ip; } { addr = "127.0.0.1";} ];
    };

    services.tor.hiddenServices.sshd = mkIf cfg.tor.enable {
      map = [ { port = cfg.port; toPort = cfg.port; } ];
      version = 3;
    };

    custom.services.endlessh = mkIf cfg.endlessh.enable {
      enable = true;
      port = cfg.endlessh.port;
    };

  };
}

# { pkgs, lib, config, ... }:

# let cfg = config.cadey.tailscale;
# in with lib; {
#   options.cadey.tailscale = {
#     enable = mkEnableOption "Enables Tailscale";

#     port = mkOption {
#       type = types.port;
#       default = 41641;
#       description = "The port to listen on for tunnel traffic (0=autoselect).";
#     };

#     package = mkOption {
#       type = types.package;
#       default = pkgs.tailscale;
#       defaultText = "pkgs.tailscale";
#       description = "The package to use for tailscale";
#     };

#     notifySupport = mkEnableOption "Enables systemd-notify support";

#     autoprovision = {
#       enable = mkEnableOption "Automatically provision this with an API key?";

#       key = mkOption {
#         type = types.str;
#         description = "The API secret used to provision Tailscale access";
#       };
#     };
#   };

#   config = mkIf cfg.enable {
#     environment.systemPackages = with pkgs; [ tailscale ];

#     systemd.packages = [ cfg.package ];
#     systemd.services.tailscale = {
#       description = "Tailscale client daemon";

#       after = [ "network-pre.target" ];
#       wants = [ "network-pre.target" ];
#       wantedBy = [ "multi-user.target" ];

#       unitConfig = {
#         StartLimitIntervalSec = 0;
#         StartLimitBurst = 0;
#       };

#       serviceConfig = {
#         ExecStart = "${cfg.package}/bin/tailscaled --port ${toString cfg.port}";

#         RuntimeDirectory = "tailscale";
#         RuntimeDirectoryMode = 755;

#         StateDirectory = "tailscale";
#         StateDirectoryMode = 750;

#         CacheDirectory = "tailscale";
#         CacheDirectoryMode = 750;

#         Restart = "on-failure";
#       } // (mkIf cfg.notifySupport {
#         ExecStart = "${cfg.package}/bin/tailscaled --port ${toString cfg.port}";

#         RuntimeDirectory = "tailscale";
#         RuntimeDirectoryMode = 755;

#         StateDirectory = "tailscale";
#         StateDirectoryMode = 750;

#         CacheDirectory = "tailscale";
#         CacheDirectoryMode = 750;

#         Restart = "on-failure";
#         Type = "notify";
#       });
#     };

#     systemd.services.tailscale-autoprovision = mkIf cfg.autoprovision.enable {
#       description = "Tailscale autoprovision hack";

#       after = [ "network-pre.target" "tailscale.service" ];
#       wants = [ "network-pre.target" "tailscale.service" ];
#       wantedBy = [ "multi-user.target" ];

#       serviceConfig = {
#         Type = "oneshot";
#         RuntimeDirectory = "tailscale";
#         RuntimeDirectoryMode = 755;

#         StateDirectory = "tailscale";
#         StateDirectoryMode = 750;

#         CacheDirectory = "tailscale";
#         CacheDirectoryMode = 750;
#       };

#       script = ''
#         ${cfg.package}/bin/tailscale up --authkey=${cfg.autoprovision.key}
#       '';
#     };
#   };
# }

