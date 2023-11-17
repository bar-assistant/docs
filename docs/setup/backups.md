# Backup and restoring

As a server admin you will be responsible for all your data. Bar Assistant includes some commands to make that process easier.

## Files

All the files you need to backup are located in applications `storage/bar-assistant` directory. Or in whatever volume you mounted this with docker. This folder contains the database file in sqlite format (`*.sqlite`) and the uploaded images (`uploads/` folder).

## Full backup via CLI

If you want to backup all your data to a .zip file, you can use the following command: `php artisan bar:full-backup`. This will create a .zip file with all your data and will be located at `storage/bar-assistant/backups` folder.

## Meilisearch

There is currently no point in backuping up the meilisearch data unless you are using custom API keys. When you restart Bar Assistant container the data gets automatically synced with Meilisearch. Or you can use `php artisan bar:refresh-search --clear` command to update the index.
