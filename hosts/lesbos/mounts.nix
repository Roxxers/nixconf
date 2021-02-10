{...}:

{
  # # Mounts
  fileSystems."/srv/books" = {
    device = "zpool/books";
    fsType = "zfs";
  };
  fileSystems."/srv/dump" = {
    device = "zpool/dump";
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
    /srv/books    192.168.0.0/24(rw,sync) 10.0.0.0/21(rw,sync)
    /srv/dump     192.168.0.0/24(rw,sync) 10.0.0.0/21(rw,sync)
    /srv/music    192.168.0.0/24(rw,sync) 10.0.0.0/21(rw,sync)
    /srv/videos   192.168.0.0/24(rw,sync) 10.0.0.0/21(rw,sync)
    /srv/pictures 192.168.0.0/24(rw,sync) 10.0.0.0/21(rw,sync)
  ''; # TODO Refactor this shit into function
  networking.firewall.allowedTCPPorts = [ 2049 ]; # nfs port
}