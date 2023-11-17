---
hide:
  - navigation
---

# Usage

Bar Assistant comes with some basic data included. You can view and contribute to that data via this repository: https://github.com/bar-assistant/data

## Export recipes

You can export all cocktail recipes from your bar by using the CLI. Running `php artisan bar:export-recipes {barId}` will generate a .zip file with all cocktail recipes, ingredients and images. This will be available via endpoints soon.

## Recipe importing

You can import recipes through a various sources. If you are missing some options go on github and ask for a new feature.

### Import from .zip

If you previously exported recipes with `php artisan bar:export-recipes {barId}` command, you can use `php artisan bar:import-zip {path}` command to import those recipes. You will have to provide either existing bar id or you will have an option to create a new one. This will be available via endpoints soon.

### Import from website

With Bar Assistant you can scrape cocktail recipes directly from the given webpage. Every website has it's scraper class located in `Kami\Cocktail\Scraper\Sites` namespace. If a website is not officially supported Bar Assistant will still try to extract recipe information.

### Import from YAML/JSON

You can import recipes via custom YAML/JSON format.

### Import from Bar Assistant collection

You can import a collection of recipes from another Bar Assistant instance.
