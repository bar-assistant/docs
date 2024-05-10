# Migration - v1.x to v1.5

Bar Assistant version 1.5 includes an overhaul of docker image:

- Now using PHP-fpm and Nginx
- New volume mapping: `/var/www/cocktails/storage/bar-assistant`
- Improved error logging
- Included docker compose configuration now exposes only one service
- Updated Meilisearch to stable version (1.0)

The basic migration steps are:

- Backup old data into a single folder
- Remove old services
- Switch to new configration
- Use the folder with backup data as a volume
- Start the services
- Update Meilisearch user API keys

## Step 1: Backup your existing data

Go into your existing docker compose folder and run the following commands:

``` bash
# First create a folder that will store your backup
$ mkdir my-bar-data
# Backup database
$ docker compose cp bar-assistant:/var/www/cocktails/storage/database.sqlite ./my-bar-data/database.sqlite
# Backup images
$ docker compose cp bar-assistant:/var/www/cocktails/storage/uploads ./my-bar-data
```

You should now have a directory `my-bar-data` in your docker compose folder with the following contents: `database.sqlite` and `uploads/` folder.

This is the most important step, as long as you don't lose this folder your data is safe.

## Step 2: Stop old services

We can remove/change the data volume attached to meilisearch since all the data will be re-synced when Bar Assistant server starts.

```bash
# Remove volume related to Meilisearch
$ docker compose rm -s -v meilisearch

# Stop and remove services
$ docker compose down
```

## Step 3: Update your compose file

Use the example from the [setup guide](index.md).

The only changes you need to do is to update volume configuration to use your backup folder, and update exposed port of the webserver service.

```yaml title="docker-compose.yml"
# ...
    restart: unless-stopped
    volumes:
      - ./my-bar-data:/var/www/cocktails/storage/bar-assistant
# ...
  webserver:
    image: nginx:alpine
    restart: unless-stopped
    ports:
      - 3000:3000
# ...
```

## Step 4: Run the containers

Before running the containers, make sure you set permissions for your backup folder to user `33` (www-data).

```bash
$ sudo chown -R 33:33 my-bar-data
```

Then run the container.

```bash
$ docker compose up -d
```

When the services are up, make sure to update API keys.

```bash
$ docker compose exec bar-assistant php artisan bar:refresh-user-search-keys
```
