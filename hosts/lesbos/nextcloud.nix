{...}:
let 
database_name = "nextcloud";
database_user = "nextcloud";
in
{
  networking.firewall = {
    allowedTCPPorts = [ 80 443 ];
  };
  services.nginx = {
    enable = true;
    # Use recommended settings
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

    virtualHosts = {
      "cloud.awoo" = {
        forceSSL = true;
        sslCertificate = "/run/keys/sslCert";
        sslCertificateKey = "/run/keys/sslKey";
      };
    };
  };

  services.nextcloud = {
    enable = true;
    hostName = "cloud.awoo";

    # Use HTTPS for links
    https = true;
      
    # Auto-update Nextcloud Apps
    autoUpdateApps.enable = true;
    # Set what time makes sense for you
    autoUpdateApps.startAt = "05:00:00";
    config = {
      # Further forces Nextcloud to use HTTPS
      overwriteProtocol = "http";
      extraTrustedDomains = [ "10.0.0.2" "cloud.queerdorks.awoo" ];

      # Nextcloud PostegreSQL database configuration, recommended over using SQLite
      dbtype = "pgsql";
      dbuser = database_user;
      dbhost = "/run/postgresql"; # nextcloud will add /.s.PGSQL.5432 by itself
      dbname = database_name;
      dbpassFile = "/run/keys/nextcloud_db";

      adminpassFile = "/run/keys/nextcloud_admin";
      adminuser = "admin";
    };
  };

  services.postgresql = {
    enable = true;

    # Ensure the database, user, and permissions always exist
    ensureDatabases = [ database_name ];
    ensureUsers = [
      { 
        name = "nextcloud";
        ensurePermissions."DATABASE nextcloud" = "ALL PRIVILEGES";
      }
    ];
  };

  systemd.services."nextcloud-setup" = {
    requires = ["postgresql.service"];
    after = ["postgresql.service"];
  };

  users.users."nextcloud".extraGroups = [ "keys" ];

  deployment.keys = {
    nextcloud_db = {
      text = builtins.readFile ../../secrets/lesbos/nextcloud_db_pass;
      user = "nextcloud";
      group = "nextcloud";
      permissions = "0400";
    };
    nextcloud_admin = {
      text = builtins.readFile ../../secrets/lesbos/nextcloud_admin_pass;
      user = "nextcloud";
      group = "nextcloud";
      permissions = "0400";
    };
    scarif-1_ssh = {
      text = builtins.readFile ../../secrets/lesbos/scarif-1.ssh.key;
      user = "nextcloud";
      group = "keys";
      permissions = "0400";
    };
    nextcloud_backup_pass = {
      text = builtins.readFile ../../secrets/lesbos/nextcloud_backup_pass;
      user = "nextcloud";
      group = "keys";
      permissions = "0400";
    };
  };

  # BACKUP
  services.borgbackup.jobs.nextcloud = {
    user = "nextcloud"; 
    group = "keys";
    startAt = "05:37:00"; # https://www.man7.org/linux/man-pages/man7/systemd.time.7.html
    paths = [ "/tmp/nextcloud" ];
    repo = "ssh://u218033@u218033.your-storagebox.de:23/./backups/lesbos/nextcloud";
    environment.BORG_RSH = "ssh -i /run/keys/scarif-1_ssh";
    encryption = {
      passCommand = "cat /run/keys/nextcloud_backup_pass";
      mode = "repokey";
    };
    prune = {
      keep = {
        daily = 7;
      };
    };
    preHook = ''
    # Lock data, move it, backup db, and then unlock nextcloud so reduce inconsistency and minimal user interruption
    /run/current-system/sw/bin/nextcloud-occ maintenance:mode --on
    DATE=$(date +"%Y%m%d")
    BACKUP_DIR=/tmp/nextcloud
    mkdir "$BACKUP_DIR"
    /run/current-system/sw/bin/rsync -Aavx /var/lib/nextcloud/ $BACKUP_DIR/dirbkp_$DATE/
    PGPASSWORD="$(cat /run/keys/nextcloud_db)" /run/current-system/sw/bin/pg_dump nextcloud -U nextcloud -f $BACKUP_DIR/nextcloud-sqlbkp_$DATE.sql.bak
    /run/current-system/sw/bin/nextcloud-occ maintenance:mode --off
    '';
    postHook = ''
    # Remove backups from /tmp
    rm -r /tmp/nextcloud
    '';
  };
}