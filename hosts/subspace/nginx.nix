{...}:
{
  networking.firewall = {
    allowedTCPPorts = [ 80 443 ];
  };
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    #recommendedTlsSettings = true;
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
    };
  };
  # Optional: You can configure the email address used with Let's Encrypt.
  # This way you get renewal reminders (automated by NixOS) as well as expiration emails.
  security.acme.certs = {
    "onion.queerdorks.club".email = "me@roxxers.xyz";
    "cloudn.queerdorks.club".email = "me@roxxers.xyz";
  };
  security.acme.acceptTerms = true;
}