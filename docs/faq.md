# FAQ

## How do I disable new user registrations?

You can disable `/register` endpoint with environment variable.

``` env
ALLOW_REGISTRATION=false
```

## Why am I missing images of cocktails and ingredients?

Check that you have correctly configured your docker volumes.

It can also mean that there are missing attributes in your indexes. You can run the following command to sync cocktails and ingredients to their indexes:

``` bash
# Docker compose commands:
# Sync cocktails
$ docker compose exec -it bar-assistant php artisan scout:import "Kami\\Cocktail\\Models\\Cocktail"
# Sync ingredients
$ docker compose exec -it bar-assistant php artisan scout:import "Kami\\Cocktail\\Models\\Ingredient"
```

## How do I update Meilisearch?

To update your meilisearch instance, you first need to create a dump of your database. Bar Assistant has a command that will create a dump task.

``` bash
$ docker compose exec -it bar-assistant php artisan bar:dump-search
```

Then follow the rest of the [steps described in meilisearch docs](https://docs.meilisearch.com/learn/cookbooks/docker.html#generating-dumps-and-updating-meilisearch).

## How do I make a specific user an administrator?

To give admin rights to a specific user you can use the following command.

``` bash
$ php artisan bar:make-admin "user@email.com"
```
