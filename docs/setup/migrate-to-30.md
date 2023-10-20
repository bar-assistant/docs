# Migration - v2.x to v3.x

If you are using docker compose this process is really simple.

First make sure you are on latest v2.x version (v2.6.0 at the time of writing).

Update your docker compose with new versions.

``` yaml
# For bar assistant server
image: barassistant/server:v3
# For salt rim
image: barassistant/salt-rim:v2
```

Then pull and restart the stack:

``` bash
$ docker compose pull
$ docker compose up -d
```

On first start your current data will be backed up to `your-volume/bar-assistant/backup_v2.zip`, then the migration will start. If something goes wrong you can downgrade to last version and restore the backup.

## Manual instructions for installs from source

If you are using SQLite with non standard database locations (meaning, not: `storage/bar-assistant/database.sqlite`), the easiest way to migrate is to copy your database to the standard location and run the migrations.
