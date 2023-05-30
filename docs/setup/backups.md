# Backup and restoring

## Instance export

If you want to dump all your data and import it into a new Bar Assistant instance you can use the following commands.

```bash
$ docker compose exec bar-assistant php artisan bar:export-zip
```

This will dump all the data that is considered shareable, like cocktails, ingredients, glasses, etc. And this will not dump any user specific data (like shopping lists, favorites, etc.).

To import this into a new instance you can use the following command:

```bash
$ docker compose exec bar-assistant php artisan bar:import-zip
```

This will scan your bar-assistant volume for .zip files and ask you which file you want to import. Please note that importing data will overwrite and delete all existing data on the isntance that you are importing to.

## Database file backup

```bash
# Via docker
$ docker cp bar-assistant:/var/www/cocktails/storage/bar-assistant/database.sqlite /path/on/host

# Via docker compose
$ docker compose cp bar-assistant:/var/www/cocktails/storage/bar-assistant/database.sqlite /path/on/host
```

## Database SQL dump

```bash
# Via cli
$ sqlite3 /var/www/cocktails/storage/bar-assistant/database.sqlite .dump > mydump.sql

# Via docker
$ docker exec bar-assistant sqlite3 /var/www/cocktails/storage/bar-assistant/database.sqlite .dump > mydump.sql

# Via docker compose
$ docker compose exec bar-assistant sqlite3 /var/www/cocktails/storage/bar-assistant/database.sqlite .dump > mydump.sql
```

## Images and files

```bash
# Via docker
$ docker cp bar-assistant:/var/www/cocktails/storage/bar-assistant/uploads /path/on/host

# Via docker compose
$ docker compose cp bar-assistant:/var/www/cocktails/storage/bar-assistant/uploads /path/on/host
```

## Meilisearch

There is currently no point in backuping up the meilisearch data unless you are using custom API keys. When you restart Bar Assistant container the data gets automatically synced with Meilisearch.
