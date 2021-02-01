{...}:

{
  # # Mounts
  # fileSystems."/mnt/media" = {
  #   device = "/dev/disk/by-uuid/0856fecd-0cdc-4a5a-aa48-8bd5faee9c3e";
  # };
  # fileSystems."/mnt/dump" = {
  #   device = "/dev/disk/by-uuid/23039c02-3713-4f2b-ac54-052d1fe1d933";
  # };
  fileSystems."/srv/books" = {
    device = "zpool/books";
    fsType = "zfs";
  };
  fileSystems."/srv/music" = {
    device = "zpool/music";
    fsType = "zfs";
  };
  fileSystems."/srv/pictures" = {
    device = "zpool/pictures";
    fsType = "zfs";
  };
  fileSystems."/srv/videos" = {
    device = "zpool/videos";
    fsType = "zfs";
  };
  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /srv/books  192.168.0.0/24(rw,sync) 10.0.0.0/21(rw,sync)
    /srv/music  192.168.0.0/24(rw,sync) 10.0.0.0/21(rw,sync)
    /srv/videos  192.168.0.0/24(rw,sync) 10.0.0.0/21(rw,sync)
    /srv/pictures  192.168.0.0/24(rw,sync) 10.0.0.0/21(rw,sync)
  ''; # TODO Refactor this shit into function
  networking.firewall.allowedTCPPorts = [ 2049 ]; # nfs port
}