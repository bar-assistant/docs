# Backup and restoring

## Using artisan commands

TODO

## Database file backup

```bash
# Via docker
$ docker cp bar-assistant:/var/www/cocktails/storage/database.sqlite /path/on/host

# Via docker compose
$ docker compose cp bar-assistant:/var/www/cocktails/storage/database.sqlite /path/on/host
```

## Database SQL dump

```bash
# Via cli
$ sqlite3 /var/www/cocktails/storage/database.sqlite .dump > mydump.sql

# Via docker
$ docker exec bar-assistant sqlite3 /var/www/cocktails/storage/database.sqlite .dump > mydump.sql

# Via docker compose
$ docker compose exec bar-assistant sqlite3 /var/www/cocktails/storage/database.sqlite .dump > mydump.sql
```

## Images and files

```bash
# Via docker
$ docker cp bar-assistant:/var/www/cocktails/storage/uploads /path/on/host

# Via docker compose
$ docker compose cp bar-assistant:/var/www/cocktails/storage/uploads /path/on/host
```

## Meilisearch

There is currently no point in backuping up the meilisearch data.
