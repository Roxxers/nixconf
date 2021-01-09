{...}:

{
  # Enable jellyfin
  services.jellyfin = {
    enable = true;
    group = "users"; # We are giving the user group access to the whole of the hdd's so this needs access to that content
  };
  users.users.nginx.extraGroups = [ "keys" ];

  services.nginx = {
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts."jellyfin.awoo" = {
      forceSSL = true;
      sslCertificate = "/run/keys/sslCert";
      sslCertificateKey = "/run/keys/sslKey";
      locations = {
        "/" = {
          proxyPass = "http://localhost:8096";
        };
      };
    };
  };
}