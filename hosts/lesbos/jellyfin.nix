{...}:

{
  # Enable jellyfin
  services.jellyfin = {
    enable = true;
    group = "users"; # We are giving the user group access to the whole of the hdd's so this needs access to that content
  };
  roxie.services.nginx = {
    enable = true;
    usesKeyDeploy = true;
    virtualHosts."jellyfin.awoo" = {
      listen = [{
        addr = "10.0.0.2";
        port = 443;
        ssl = true;
      }];
      
      forceSSL = true;
      sslCertificate = "/run/keys/sslCert";
      sslCertificateKey = "/run/keys/sslKey";
      locations = {
        "/" = {
          proxyPass = "http://localhost:8096";
        };
      };
    };
    virtualHosts."jellyfin.lan" = {
      listen = [{
        addr = "192.168.0.4";
        port = 80;
        ssl = false;
      }];
      
      locations = {
        "/" = {
          proxyPass = "http://localhost:8096";
        };
      };
    };
  };
}