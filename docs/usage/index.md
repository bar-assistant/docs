---
hide:
  - navigation
---

# Usage

Here you can find some basic inforamtion about using all the Bar Assistant features.

## Initial bar data

When you create a new bar, you can choose to start a bar with cocktails and ingredients already included. All that initial data is managed in a seperate repository and pulled when building docker image. You can view and contribute to that data via [Bar Assistant Public Data repository](https://github.com/bar-assistant/data).

## Deleting users

When a user deletes his account, to keep data integrity, all his account data gets anonymized. If you want to completely delete a user you can use the following command: `php artisan bar:delete-user {email}`. This will delete user and all his data, including cocktails, bars and ingredients he created.

### Example steps:

1. Find email of a user that you want to delete, for example: `karlo@barassistant.app`.
2. If using docker, run `docker compose exec bar-assistant php artisan bar:delete-user karlo@barassistant.app`
3. Follow on screen instructions

## Export recipes

You can export all cocktail recipes from your bar by using the CLI. Running `php artisan bar:export-recipes {barId}` will generate a .zip file with all cocktail recipes, ingredients and images.

### Example steps:

1. Find ID of a bar you want to export recipes from. You can use a basic SQL query to find a list of bars, for example: `sqlite3 storage/bar-assistant/database.ba3.sqlite 'SELECT * FROM bars'`. I'll use `31` as example bar id.
2. If using docker, run `docker compose exec bar-assistant php artisan bar:export-recipes 31`
3. Follow on screen instructions
4. You can find your .zip file in the volume you mounted: `volume/backups/202312021054_recipes.zip`

## Recipe importing

You can import recipes through a various sources. If you are missing some import options you can open a github issue and describe what would you want to be added.

### Import from .zip

If you previously exported recipes with `php artisan bar:export-recipes {barId}` command, you can use `php artisan bar:import-zip {path}` command to import those recipes. You will have to provide either existing bar id or you will have an option to create a new one. This will be available via endpoints soon.

### Import from website

With Bar Assistant you can scrape cocktail recipes directly from the given webpage. Every website has it's scraper class located in `Kami\Cocktail\Scraper\Sites` namespace. If a website is not officially supported Bar Assistant will still try to extract recipe information.

### Import from YAML/JSON

You can import recipes via custom YAML/JSON format.

### Import from Bar Assistant collection

You can import a collection of recipes from another Bar Assistant instance.
