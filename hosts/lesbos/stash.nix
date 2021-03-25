{ config, lib, ... }:

{
  # roxie.services.stash = {
  #   enable = true;
  # };
  roxie.programs.podman.enable = true;
  virtualisation.oci-containers.containers.stash = {
    image = "stashapp/stash:latest";
    environment = {
      STASH_STASH = "/data/";
      STASH_GENERATED = "/generated/";
      STASH_METADATA = "/metadata/";
      STASH_CACHE = "/cache/";
    };
    ports = [ "9999:9999" ];
    volumes = [
      ## Keep configs here.
      "/var/lib/stash/config:/root/.stash"
      ## Point this at your collection.
      "/srv/dump:/data"
      ## This is where your stash's metadata lives
      "/var/lib/stash/metadata:/metadata"
      ## Any other cache content.
      "/var/lib/stash/cache:/cache"
      ## Where to store generated content (screenshots,previews,transcodes,sprites)
      "/var/lib/stash/generated:/generated"
    ];
  };
  roxie.services.nginx = {
    usesKeyDeploy = true;
    virtualHosts."stash.awoo" = {
      listen = [{
        addr = "10.0.0.2";
        port = 443;
        ssl = true;
      }];
      forceSSL = true;
      sslCertificate = "/etc/ssl/certs/sslCert";
      sslCertificateKey = "/etc/ssl/certs/sslKey";
      locations = {
        "/" = {
          proxyPass = "http://localhost:${toString config.roxie.services.stash.port}";
        };
      };
    };
  };
}