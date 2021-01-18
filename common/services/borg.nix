let common-excludes = [
  # Largest cache dirs
  "*.nobackup"
  ".cache"
  "*/.cache"
  "*/cache"
  "*/cache2" # firefox
  "*/Cache"
  ".config/Slack/logs"
  ".config/VSCodium/*Cache*"
  ".container-diff"
  ".npm/_cacache"
  # Work related dirs
  "*/node_modules"
  "*/bower_components"
  "*/_build"
  "*/.tox"
  "*/venv"
  "*/.venv"
];
in 
{ 
  name,
  repo ? "ssh://u218033@u218033.your-storagebox.de:23/./backups",
  user ? "root",
  startAt ? "daily",
  compression ? "lz4",
  sshKey ? "/home/roxie/.ssh/scarif-1",
  encryptionCommand,
  encryptionMode ? "repokey",
  excludes ? [],
  prune ? { keep = { daily = 7; within = "1d"; }; },
  path ? ""
}: 
{
  user = "${user}";
  startAt = "${startAt}";
  repo = "${repo}/${name}";
  environment.BORG_RSH = "ssh -i ${sshKey}";
  compression = "${compression}";
  encryption = {
    passCommand = encryptionCommand;
    mode = encryptionMode;
  };
  prune = prune;
  paths = path;
  exclude = map (x: path + "/" + x) (common-excludes ++ excludes);
  extraCreateArgs = "--verbose --stats --checkpoint-interval 600";
}
