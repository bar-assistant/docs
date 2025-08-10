---
hide:
  - navigation
---

# Data management

Being in control of your data is one of the most important parts of Bar Assistant. That's why there are several ways to export your data into human and machine readable formats.

## Export data types

Here's a quick summary of all data export types. All types have recipes grouped into folders, with cocktail name (slug) being the folder name. Images are included in the root of the recipe folder.

| Type | Description | CLI/API type |
| --- | --- | --- |
| Datapack | Exports bar data(1) in JSON format, which you can use to import bar data into another Bar Assistant instance | `datapack` |
| JSON | Exports all recipes, with recipe being a [valid JSON schema](https://barassistant.app/cocktail-02.schema.json) | `json` |
| Markdown | Exports all recipes, with recipe in Markdown format | `markdown` |
| XML | Exports all recipes, with recipe in XML format | `xml` |
| JSON-LD | Exports all recipes, with recipe in [Schema.org Recipe type](https://schema.org/Recipe) | `json-ld` |
| YAML | Same structure as JSON, but in YAML format | `yaml` |

(1) Bar data includes cocktails, ingredients, methods, tags, utensils, glass types, ingredient categories, and price categories.

You can also force conversion of cocktail ingredients to a specific unit (if applicable). Available arguments for units is: `none`, `ml`, `cl`, `oz`.

## Exporting data

### Via CLI (Server owners)
You can export all cocktail recipes from your bar by using the CLI. Run `php artisan bar:export-recipes --help` to see all available options.

Here's an example using default docker setup:

- If you know ID of a bar you want to export recipes from, you can provide it as an argument to the command.

``` bash
$ docker compose exec bar-assistant php artisan bar:export-recipes {barId}
```

Otherwise, you can run the command without `{barId}` argument, and you will be able to search for a bar to export recipes from.

- You will see a succseful message with the path to the exported file.

### Via API

You can use CURL or any other HTTP client to export data.

``` bash
curl --request POST \
  --url http://{your-url}/api/exports \
  --header 'Accept: application/json' \
  --header 'Authorization: Bearer {your-token}' \
  --header 'Content-Type: application/json' \
  --data '{
  "type": "datapack",
  "bar_id": {your-bar-id}
}'
```

### Via Web UI

If you are using Salt Rim, you can use the Exports page in the settings.

## Importing data

### Import from datapack .zip (Server)

If you previously exported recipes with `php artisan bar:export-recipes {barId}` command, you can use `php artisan bar:import-zip {path}` command to import those recipes. You will have to provide either an existing bar id or you will have the option to create a new one.

You can also import any .zip file you put in backups folder. Here's an example with docker compose:

1. Move .zip file with recipes into backups folder. This folder should be available to you if you mounted it as volume, inside container its located at `/var/www/cocktails/storage/bar-assistant/backups`.
2. Run the following command with .zip path relative to mounted storage folder: `docker compose exec app php artisan bar:import-recipes backups/my-recipes.zip`
3. Follow on screen instructions

## Deleting users (Server)

When a user deletes his account, to keep data integrity, all his account data gets anonymized. If you want to completely delete a user you can use the following command: `php artisan bar:delete-user {email}`. This will delete user and all his data, including cocktails, bars and ingredients he created.

## Full backup via CLI

If you want to backup all your data to a .zip file, you can use the following command:
``` bash
$ docker compose exec bar-assistant php artisan bar:full-backup
```

This will create a .zip file with all your data and will be located at `storage/bar-assistant/backups` folder.

## Meilisearch data backup

There is currently no point in backing up the Meilisearch data unless you are using custom API keys. When you restart Bar Assistant container the data gets automatically synced with Meilisearch.
