---
hide:
  - navigation
---

# Usage

This area is still WIP...

<!-- ## Ingredients

Bar Assistant comes with some basic ingredients included. On the main page of the ingredients you can filter and search for ingredients.

From the ingredients list you can also add ingredients to your shelf or your shopping list.

Clicking on a specific ingredient will navigate you to ingredient details. This page includes some basic details of a ingredient like strength, origin, description and similar. This page also includes actions for updating and deleting an ingredient.

## Cocktails

Depending on your inital setup, Bar Assistant comes with over 100 cocktails already added. Clicking on a cocktails in navigation, will present you with a list of all cocktails available in the application. Here you can use refinements and search to filter cocktails. Currently included refinements include: **main cocktail ingredient, cocktail method, cocktail strength, tags, glass type and rating**. Also included are special filters like: **my cocktails, shelf cocktails and favorite cocktails**. Every cocktail on the list includes the rating you gave it, name, ingredients and a list of tags.

When you click on a cocktail you will see cocktail details page. This page contains more details about ingredients that go into a cocktail, possible ingredient substitutes and cocktail actions.

Inside the ingredient section you can change the number of servings and default ingredient unit. -->

## Recipe importing

You can import recipes through a various sources. If you are missing some options go on github and ask for a new feature.

### Import from website

With Bar Assistant you can scrape cocktail recipes directly from the given webpage. Every website has it's scraper class located in `Kami\Cocktail\Scraper\Sites` namespace. If a website is not officially supported Bar Assistant will still try to extract recipe information.

### Import from YAML/JSON

You can import recipes via custom YAML/JSON format.

### Import from Bar Assistant collection

You can import a collection of recipes from another Bar Assistant instance.
