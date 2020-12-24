{...}:
{
  networking.firewall = {
    allowedTCPPorts = [ 443 ];
  };
  services.nginx = {
    enable = true;
    virtualHosts."onion.queerdorks.club" = {
      enableACME = true;
      forceSSL = true;
      root = "/var/www/onion";
      basicAuth = { roxie = builtins.readFile ../../secrets/subspace/onionlistingpw;};
    };
  };
  # Optional: You can configure the email address used with Let's Encrypt.
  # This way you get renewal reminders (automated by NixOS) as well as expiration emails.
  security.acme.certs = {
    "onion.queerdorks.club".email = "me@roxxers.xyz";
  };
  security.acme.acceptTerms = true;
}