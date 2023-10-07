---
hide:
  - navigation
---

# FAQ

Here you can find frequently asked questions and their answers.

## How do I disable new user registrations?

You can disable `/register` endpoint with environment variable.

```bash
ALLOW_REGISTRATION=false
```

## Why am I missing images of cocktails and ingredients?

Firstly, check that you have correctly configured your docker volumes. You should have an uploads folder with all the images inside it.

It can also mean your are missing some attributes in your search indexes. You can run the following command to re-sync cocktails and ingredients with their indexes:

``` bash
# Docker compose commands:
# Sync cocktails
$ docker compose exec -it bar-assistant php artisan scout:import "Kami\\Cocktail\\Models\\Cocktail"
# Sync ingredients
$ docker compose exec -it bar-assistant php artisan scout:import "Kami\\Cocktail\\Models\\Ingredient"
```

## How do I update Meilisearch?

### The easy way

Everytime you restart Bar Assistant container the cocktail and ingredient data gets synced with Meilisearch. So the easiest way to update the Meilisearch is to delete the container and the volume, and create a new one.

``` bash
$ docker compose rm -vs meilisearch
```

And then restart the Bar Assistant container to recreate the indexes

``` bash
$ docker compose restart bar-assistant
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
