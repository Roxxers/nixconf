{...}:

{
  # Enable jellyfin
  services.jellyfin = {
    enable = true;
    group = "users"; # We are giving the user group access to the whole of the hdd's so this needs access to that content
  };
  # Can remove later when we sort out reverse proxy
  networking.firewall.allowedTCPPortRanges = [
    { from = 8096; to = 8096; }
  ];
}