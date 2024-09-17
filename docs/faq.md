---
hide:
  - navigation
---

# FAQ

Here you can find frequently asked questions and their answers.

## Why do I get "Unable to connect to X API server." on a login page?

This usually means that the client can't reach the API server. There could be a few reasons for this:

- The API server is not running
    - Restart the API server
    - Check docker logs for errors
- The API server is running but your browser can't reach it
    - Check that the API server is reachable from your browser.
    - **Example using default setup:** When you visit "http://localhost:3000/bar" you should see: "This is your Bar Assistant instance." message.

## Why am I missing some features in web app?

Salt Rim uses background workers to power the web frontend and PWA and the browser usually caches files related to this. To verify that you have a cache issue try another browser or your current browser's incognito mode to check out the frontend.

## How do I disable user registrations?

You can disable `/register` endpoint with environment variable.

```bash
ALLOW_REGISTRATION=false
```

## How do I backup my data?

To create a full backup of your data, you can use the CLI commands.

``` bash
$ docker compose exec bar-assistant php artisan bar:full-backup
```

This will create a backup file in the volume you mounted. Path to the .zip file should be printed by command.

This is a full "file" backup of your data, which includes the current database file, and the whole uploads directory.

## How do I update Meilisearch?

### The easy way

Everytime you restart Bar Assistant container the cocktail and ingredient data gets synced with Meilisearch. So the easiest way to update the Meilisearch is to delete the container and the related volume, and create a new one.

``` bash
# Stop the container
$ docker compose stop meilisearch
# Remove the container and related volume, please check if volume is deleted
$ docker compose rm meilisearch -v
# Pull new images
$ docker compose pull
# Restart the stack
$ docker compose restart
```

Update your `docker-compose.yml` file with new Meilisearch version, and run the stack.

``` bash
$ docker compose up -d
```

### The "proper" way

If, for some reason, you need all the current data in the Meilisearch, you can follow the official guide on how to update.

To update your Meilisearch instance, you first need to [create a dump of your database](https://docs.meilisearch.com/learn/cookbooks/docker.html#generating-dumps-and-updating-meilisearch). Then follow the rest of the instructions on the Meilisearch docs.

## How do I check logs?

Most of the logs are available in docker output. Depending on the configuration, some Bar Assistant specific logs are also written inside the container in the file: `/var/www/cocktails/storage/logs/laravel.log`.

``` bash
$ docker compose logs bar-assistant
$ docker compose logs salt-rim
```

## Where can I find API documentation?

Visit `/docs` path on your API instance, ex: https://your-bar-api-server.com/docs

## Where do I find more recipes?

Some of Bar Assistant community members are hosting their recipe databases:

- [zhdenny/bar_assistant_database](https://github.com/zhdenny/bar_assistant_database)
- [bar-assistant/data](https://github.com/bar-assistant/data)

Or you can visit some of sites that Bar Assistant can import recipes from:

- [PunchDrink](https://punchdrink.com/)
- [Imbibe](https://imbibemagazine.com/)
- [Liquor.com](https://www.liquor.com/)
- [CocktailParty](https://cocktailpartyapp.com/)
