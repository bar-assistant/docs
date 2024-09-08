---
hide:
  - navigation
---

# Data management

We belive that being in control of your data is one of the most important parts of Bar Assistant. That's why we offer several ways to export your data, and we try to document as much as possible so you can easily import that data into another service.

## Export data types

Here's a quick summary of all data export types. All types have recipes grouped into folders, with cocktail name (slug) being the folder name. Images are included in the root of the recipe folder.

| Type | Description | CLI/API type |
| --- | --- | --- |
| Datapack | Exports bar data(1) in JSON format, which you can use to import bar data into another Bar Assistant instance | `datapack` |
| JSON | Exports all recipes, with recipe being a [valid JSON schema](https://barassistant.app/cocktail-02.schema.json) | `schema` or `json` |
| Markdown | Exports all recipes, with recipe in Markdown format | `markdown` or `md` |
| XML | Exports all recipes, with recipe in XML format | `xml` |
| JSON+LD | Exports all recipes, with recipe in [Schema.org Recipe type](https://schema.org/Recipe) | `json+ld` |

(1) Bar data includes cocktails, ingredients, methods, tags, utensils, glass types, ingredient categories, and price categories.

## Exporting data

### Via CLI (Server owners)
You can export all cocktail recipes from your bar by using the CLI. Running `php artisan bar:export-recipes {barId}` will generate a Datapack export file by default. You can also generate other types of exports by using `--type` option.

1. Find ID of a bar you want to export recipes from. You can use a basic SQL query to find a list of bars, for example: `sqlite3 storage/bar-assistant/database.ba3.sqlite 'SELECT * FROM bars'`. I'll use `31` as example bar id.
2. If using docker, run `docker compose exec bar-assistant php artisan bar:export-recipes 31`
3. Follow on-screen instructions
4. You can find your .zip file in the volume you mounted: `volume/backups/202312021054_recipes.zip`

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

Importing is supported only for Datapack and JSON data types.