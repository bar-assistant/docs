---
hide:
  - navigation
---

# Usage

## Ingredients

Bar Assistant comes with some basic ingredients included. On the main page of the ingredients you can filter and search for ingredients.

From the ingredients list you can also add ingredients to your shelf or your shopping list.

Clicking on a specific ingredient will navigate you to ingredient details. This page includes some basic details of a ingredient like strength, origin, description and similar. This page also includes actions for updating and deleting an ingredient.

## Cocktails

Depending on your inital setup, Bar Assistant comes with over 100 cocktails already added. Clicking on a cocktails in navigation, will present you with a list of all cocktails available in the application. Here you can use refinements and search to filter cocktails. Currently included refinements include: **main cocktail ingredient, cocktail method, cocktail strength, tags, glass type and rating**. Also included are special filters like: **my cocktails, shelf cocktails and favorite cocktails**. Every cocktail on the list includes the rating you gave it, name, ingredients and a list of tags.

When you click on a cocktail you will see cocktail details page. This page contains more details about ingredients that go into a cocktail, possible ingredient substitutes and cocktail actions.

Inside the ingredient section you can change the number of servings and default ingredient unit.

## Recipe scraping

With Bar Assistant you can scrape cocktail recipes directly from the given webpage. Every website has it's scraper class located in `Kami\Cocktail\Scraper\Sites` namespace.

You can import recipe directly from the web client by visiting `/cocktails/scrape` path, or via command line.

To import a recipe via command line, check the following command:

``` bash
$ php artisan bar:scrape --help
```

**Please note that this feature is error prone, mainly when it comes to ingredient parsing.**

Example with [TuxedoNo2 website](https://tuxedono2.com/):

``` bash
# Run full scraping
$ php artisan bar:scrape https://tuxedono2.com/coco-no-coco-cocktail-recipe

# Don't import the ingredients
$ php artisan bar:scrape -i https://tuxedono2.com/coco-no-coco-cocktail-recipe

# Overwrite name and add custom tags
$ php artisan bar:scrape --tags=custom,tags,lorem --name="My imported recipe" https://tuxedono2.com/coco-no-coco-cocktail-recipe

# Also you can run it from docker
$ docker compose exec -it bar-assistant php artisan bar:scrape https://tuxedono2.com/coco-no-coco-cocktail-recipe
```
