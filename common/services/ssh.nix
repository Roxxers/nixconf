{ config, lib, ... }: 
let cfg = config.roxie.sshd;
in with lib; {
  imports = [ ./endlessh.nix ]; 
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
      # Restrict key exchange, cipher, and MAC algorithms, as per sshaudit.com hardening guide
      macs = [ "hmac-sha2-512-etm@openssh.com" "hmac-sha2-256-etm@openssh.com" "umac-128-etm@openssh.com" ];
      kexAlgorithms = [ "curve25519-sha256@libssh.org" "curve25519-sha256" "diffie-hellman-group16-sha512" "diffie-hellman-group18-sha512" "diffie-hellman-group14-sha256" "diffie-hellman-group-exchange-sha256" ];
      extraConfig = ''
PubkeyAuthentication yes
AuthenticationMethods publickey
UsePAM yes
Protocol 2
ClientAliveInterval 300
ClientAliveCountMax 2
HostKeyAlgorithms ssh-ed25519,ssh-ed25519-cert-v01@openssh.com,sk-ssh-ed25519@openssh.com,sk-ssh-ed25519-cert-v01@openssh.com,rsa-sha2-256,rsa-sha2-512,rsa-sha2-256-cert-v01@openssh.com,rsa-sha2-512-cert-v01@openssh.com
'';
      listenAddresses = mkIf cfg.wgSupport.enable [ { addr = cfg.wgSupport.ip; } { addr = "127.0.0.1";} ];
    };

    services.tor.relay.onionServices.sshd = mkIf cfg.tor.enable {
      map = [ { port = cfg.port; } ];
      version = 3;
    };

    custom.services.endlessh = mkIf cfg.endlessh.enable {
      enable = true;
      port = cfg.endlessh.port;
    };

  };
}
