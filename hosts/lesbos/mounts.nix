{...}:

{
  # Mounts
  fileSystems."/mnt/media" = {
    device = "/dev/disk/by-uuid/0856fecd-0cdc-4a5a-aa48-8bd5faee9c3e";
  };
  fileSystems."/mnt/dump" = {
    device = "/dev/disk/by-uuid/23039c02-3713-4f2b-ac54-052d1fe1d933";
  };
  fileSystems."/srv/media" = {
    device = "/mnt/media";
    options = [ "bind" ];
  };
  fileSystems."/srv/dump" = {
    device = "/mnt/dump";
    options = [ "bind" ];
  };
  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /srv/media  192.168.0.0/24(rw,sync) 10.0.0.0/21(rw,sync)
    /srv/dump  192.168.0.0/24(rw,sync) 10.0.0.0/21(rw,sync)
  '';
  networking.firewall.allowedTCPPorts = [ 2049 ]; # nfs port
}