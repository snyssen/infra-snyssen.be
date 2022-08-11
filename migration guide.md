# Migrate from old infrastructure to new IaC one

The production server is at snyssen.be (192.168.1.10).\
The staging server is at snyssen.duckdns.org (192.168.1.12).\
The backup server is at backup.snyssen.be (192.168.1.11).\
Guest refer to the development machine (the machine you are reading this guide from basically).

The operation consists of first restoring a copy of the prod server onto the staging server data wise, then backing up up the staging server, scratching the production server and finally restoring the staging server backup as production.

Here are the steps:

1. From the production server, run two backups to the backup server: /mnt/storage (WARNING: this will take literal **hours** or even **days**) and /home/snyssen/docker_mounts
2. Install latest Fedora server version onto staging server
3. From guest, run from-scratch playbook **without starting apps** (apps-deploy has to be modified so a flag can be set for this)
4. Now restore app by app:
   1. Nextcloud:
      1. From staging, start nextcloud_postgres and nextcloud_postgres_backups: `docker-compose up -d nextcloud_postgres nextcloud_postgres_backups`
      2. From staging, restore `/mnt/storage/nextcloud_dumps` with restic to get access to latest dumps
      3. Fix the latest dump:
         1. Edit the file to remove `CREATE/ALTER ROLE` commands as the container already defines the role to use
         2. Run `sed -i -e 's/\boc_snyssen\b/nextcloud/g' -e 's/oc_//g' $FILENAME`. This is necessary because old server used `oc_snyssen` user and `oc_` prefixes everywhere
      4. Move the dump to `/mnt/storage/backups/nextcloud/` so it can be accessed by nextcloud_postgres_backups
      5. Restore the dump: `docker exec -it nextcloud_postgres_backups /bin/sh -c "cat /backups/$FILENAME | psql -U nextcloud -d nextcloud -h nextcloud_postgres -W"`
      6. Restore `/mnt/storage/nextcloud` with restic
      7. Fix `/mnt/storage/nextcloud/config/config.php`: Check db settings (should connect with nextcloud user and not use any table prefix), add staging domain to trusted domain
      8. Start nextcloud stack and check everything is okay
   2. Photoprism:
      1. From staging, restore `/mnt/storage/pictures` with restic
      2. For this service we won't restore anything from old server, rest of configuration is done from scratch.
   3. Recipes:
      1. From staging, start recipes_postgres and recipes_postgres_backups: `docker-compose up -d recipes_postgres recipes_postgres_backups`
      2. From staging, restore `/mnt/storage/recipes` with restic
      3. Fix the latest dump from `/mnt/storage/recipes/dumps`: Edit the file to remove `CREATE/ALTER ROLE` commands as the container already defines the role to use
      4. Move latest database dump to `/mnt/storage/backups/recipes` so it can be accessed by recipes_postgres_backups.
      5. Restore the dump: `docker exec -it recipes_postgres_backups /bin/sh -c "cat /backups/$FILENAME | psql -U djangouser -d djangodb -h recipes_postgres -W"`
   4. Streaming:
      1. From staging, restore with restic:
         - These could be used to restore settings etc. but I actually think we should restart from sratch...:
            - `/home/snyssen/docker_mounts/jellyfin/config/data` to `/home/snyssen/data/jellyfin/data`
            - `/home/snyssen/docker_mounts/jellyfin/config` to `/home/snyssen/data/jellyfin/config` **but** exclude `cache`, `custom-cont-init.d`, `custom-services.d`, `data` and `log`
            - (optional) `/home/snyssen/docker_mounts/jellyfin/config/cache` to `/home/snyssen/data/jellyfin/cache`
         - `/mnt/storage/movies` to `/mnt/storage/streaming/media/movies`
         - `/mnt/storage/music` to `/mnt/storage/streaming/media/music`
         - `/mnt/storage/TV_shows` to `/mnt/storage/streaming/media/tv`
      2. Other services won't be restored, they will have to be configured from scratch.
      3. Start stack then go into the libraries settings of jellyfin. Fix the libraries paths from there.
