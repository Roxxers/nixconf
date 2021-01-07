{ config, ... }:

{
  services.borgbackup.jobs = {
    documents = {
      user = "roxie";
      startAt = "0 */4 * * *"; # every 4 hours cronjob style https://www.man7.org/linux/man-pages/man7/systemd.time.7.html
      paths = [ "/home/roxie" ];
      repo = "ssh://u218033@u218033.your-storagebox.de:23/./backups/documents";
      exclude = [ "*.nobackup" "/home/roxie/.cache" "/home/roxie/Downloads" "*/node_modules" "*/*venv" ];
      environment.BORG_RSH = "ssh -i /home/roxie/.ssh/scarif-1";
      encryption = {
        passCommand = "cat /home/roxie/.config/borg/.documents.pass";
        mode = "repokey";
      };
      prune = {
        keep = {
          daily = 7;
          within = "1d";
        };
      };
    };
  };
}
