{...}:
let
bitwardenReverseProxy = {
  extraConfig = ''client_max_body_size 128M;
    proxy_buffers 8 1024k;  
    proxy_buffer_size 1024k;
    client_body_temp_path /tmp 1 2;
    client_body_buffer_size 256k;
    client_body_in_file_only off;
  '';
  locations."/" = {
    proxyPass = "http://localhost:8812"; #changed the default rocket port due to some conflict
    proxyWebsockets = true;
  };
  locations."/notifications/hub" = {
    proxyPass = "http://localhost:3012";
    proxyWebsockets = true;
  };
  locations."/notifications/hub/negotiate" = {
    proxyPass = "http://localhost:8812";
    proxyWebsockets = true;
  };
};
in
{
  networking.firewall = {
    allowedTCPPorts = [ 80 443 ];
  };
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";
    virtualHosts = {
      "onion.queerdorks.club" = {
        enableACME = true;
        forceSSL = true;
        root = "/var/www/onion";
        basicAuth = { 
          roxie = builtins.readFile ../../secrets/subspace/onionlistingpw;
        };
      };
      "cloudn.queerdorks.club" = {
        enableACME = true;
        forceSSL = true;
        locations = {
          "/" = {
            proxyPass = "https://cloud.awoo";
          };
        };
        basicAuth = { 
          roxie = builtins.readFile ../../secrets/subspace/cloudproxy_pw_roxie;
          emily = builtins.readFile ../../secrets/subspace/cloudproxy_pw_emily ;
        };
      };
      "bitwarden.awoo" = bitwardenReverseProxy // {
        listen = [{
          addr = "10.0.3.1";
          port = 443;
          ssl = true;
        }];
        sslCertificate = "/run/keys/bitwarden.sslCert";
        sslCertificateKey = "/run/keys/bitwarden.sslKey";
        forceSSL = true;
      };
      "bitwarden.onion" = bitwardenReverseProxy // {
        listen = [ {
          addr = "127.0.0.1";
          port = 80;
        } ];
        serverName = builtins.readFile ../../secrets/subspace/bitwarden/onionsite;
      };
    };
  };
  users.users."nginx".extraGroups = [ "keys" ];
  deployment.keys = {
    "bitwarden.sslCert" = {
      text = builtins.readFile ../../secrets/subspace/bitwarden/cert.pem;
      user = "nginx";
      group = "nginx";
    };
    "bitwarden.sslKey" = {
      text = builtins.readFile ../../secrets/subspace/bitwarden/key.pem;
      user = "nginx";
      group = "nginx";
    };
  };

  services.tor.relay.onionServices.bitwarden = {
    map = [ 80 ];
    version = 3;
  };
  # Optional: You can configure the email address used with Let's Encrypt.
  # This way you get renewal reminders (automated by NixOS) as well as expiration emails.
  security.acme.certs = {
    "onion.queerdorks.club".email = "me@roxxers.xyz";
    "cloudn.queerdorks.club".email = "me@roxxers.xyz";
  };
  security.acme.acceptTerms = true;
}