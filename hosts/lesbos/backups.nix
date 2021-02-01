{ config, ... }:

let borgJob = import ../../common/services/borg.nix;
in
{
  services.borgbackup.jobs = {
    media = borgJob {
      name="media";
      user="root";
      group="keys";
      sshKey = "/run/keys/scarif-1_ssh";
      encryptionCommand="cat /run/keys/mediabackup";
      path = "/mnt/dump";
      excludes = [ "*/OnlyFans"
      ];
    };
  };
}
