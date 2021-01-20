{ config, ... }:

let borgJob = import ../../common/services/borg.nix;
in
{
  services.borgbackup.jobs = {
    documents = borgJob {
      name="documents";
      user="roxie";
      group="users";
      startAt="*-*-* 0/4:00:00";
      encryptionCommand="cat /home/roxie/.config/borg/.documents.pass";
      path = "/home/roxie";
      excludes = [ 
        "Downloads"
        "code/go/pkg"
        "code/go/bin" # Dont backup pulled packages or binaries we can compile again
        ".var"
        ".config/discord"
      ] ++ 
      (map (x: ".local/share/" + x) ["lutris/runners" "lutris/runtime" "baloo" "Trash" "Steam"]);
    } // rec {
      #prune.prefix = "";
    };
  };
}
