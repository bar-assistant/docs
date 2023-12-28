---
hide:
  - navigation
---

# Usage

Here you can find some information about using some of the Bar Assistant features.

## Initial bar data

When you create a new bar, you can choose to start a bar with cocktails and ingredients already included. All that initial data is managed in a separate repository and pulled when building a docker image. You can view and contribute to that data via the [Bar Assistant Public Data repository](https://github.com/bar-assistant/data).

<!-- ![Screenshot](assets/screenshots/bar-create.png) -->

## Showing what recipes you can make

All cocktails that you can make and ingredients that you have are managed via "Shelf". To see what recipes you can make you need to add all ingredients that you have to your shelf.

1. Go to "Ingredients" page
2. Search or create an ingredient that you want to add to your shelf
3. Click "Add to shelf" action
4. Go to "Cocktails" page
5. In filters check "Cocktails I can make" checkbox

## Adding recipes

You can easily create new cocktail recipes by click "Create cocktail" button on "Cocktails" page. From that page you can manage all data related to the recipe including ingredients, tags, images and more.

You can also import recipes through various sources. If you are missing some import options you can open a [GitHub issue](https://github.com/karlomikus/bar-assistant) and describe what would you want to be added.

### Import from website

With Bar Assistant you can scrape cocktail recipes directly from the given webpage. Some websites are officially supported but Bar Assistant will try to extract recipe data from any link you give it.

After you import recipe from the URL you will be presented with all the data that was found. Here you can double-check if everything is correct and keep it in sync with your data. Ingredients will be automatically matched by their name, if the ingredient is not found it will be created. You can also manually match ingredients.

### Import from YAML/JSON

You can import recipes via custom YAML/JSON format, previously exported from another Bar Assistant recipe.

### Import from Bar Assistant collection

You can import a collection of recipes from another Bar Assistant instance.

### Import from .zip (Server)

If you previously exported recipes with `php artisan bar:export-recipes {barId}` command, you can use `php artisan bar:import-zip {path}` command to import those recipes. You will have to provide either an existing bar id or you will have the option to create a new one.

1. Find email of a user that you want to delete, for example: `karlo@barassistant.app`.
2. If using docker, run `docker compose exec bar-assistant php artisan bar:delete-user karlo@barassistant.app`
3. Follow on screen instructions

## Recipe collections

You can create a recipe collection in a few ways.

By manually creating collections via the "Collections" page. Then you can go to a single cocktail recipe and in the actions dropdown select "Add to collection". You can also create a new collection directly from dialog that shows up.

To add multiple recipes to collection you can use "Cocktails" page to filter what cocktails you want to add and then click "Add to collection" button in top right.

If you want to share your collection with all the members in the bar you can enable that on "Collections" page when you edit a specific collection. All shared collections will be shown in the filter sidebar od "Cocktails" page.

## Searching and filtering

You can use global search that is always available when you click "Search" in site header. This search is fast and powered by Meilisearch. From here you can also filter ingredients and cocktails.

You can also be more specific with filters when you are on main resource page.

Available cocktail filters:

- Cocktails you can make
- Favorites
- Cocktails with a public link
- Collections - including your and other bar members collections
- Recipes added by specific users
- Main ingredient - The ingredient that is in first place in the cocktail recipe is marked as the main ingredient
- Cocktail preparation method
- Cocktail strength by ABV
- Custom tags you've added
- Glass type
- Total number of ingredients
- By ratings

Available ingredient filters:

- Ingredients in your shelf
- Ingredients on your shopping list
- Ingredients used as main ingredient
- Category
- Strength

These facets combined with custom sorting give you powerful filtering capabilities.

## Sharing recipes

Bar Assistant allows you to share recipes in a few ways. All actions are available on a specific cocktail recipe page.

- Print recipe - This shows you print-friendly page with the recipe information
- Create public link - This will create a public link which you can share with your friends
- Generate recipe image - Create a recipe image that you can share with your friends
- Copy as plain text - This will copy recipe information as plain text in your clipboard
- Copy as JSON/YAML - This will copy recipe in a specific format which you can use to import it into another bar
- Copy as Markdown - This will copy recipe information in Markdown format

## User roles

There is a few user roles in the Bar Assistant.

**Admin**

Complete access to bar actions. Can't delete the bar.

**Moderator**

Can manage cocktails and ingredients. Can manage bar settings except bar members.

**General**

Can manage cocktails and ingredients.

**Guest**

Can only view, favorite and rate recipes and ingredients. Can also create collections.

!!! warning

    Keep in mind that the user that created the bar can delete it at any point (independent of the role he has). Deleting the bar also deletes all the recipes and ingredients that members added.

### Role breakdown

**Bar:**

    create: anyone
    view: bar members
    edit: bar owner, admin
    delete: bar owner
    create: anyone
    remove members: bar owner, admin

**Methods, Tags, Utensils, Ingredient categories, Glass types:**

    create: admin, moderator
    view: bar members
    edit: admin, moderator
    delete: admin, moderator

**Cocktails:**

    create: admin, moderator, general
    view: bar members
    edit: author, admin, moderator
    delete: author, admin, moderator
    create public link: author, admin, moderator
    rate: bar members
    add notes: bar members

**Ingredients:**

    create: admin, moderator, general
    view: bar members
    edit: author, admin, moderator
    delete: author, admin, moderator

**Users:**

    create: admin, moderator
    view: admin, moderator
    edit: admin, moderator
    delete: only user can delete his own account

## Export recipes (Server)

You can export all cocktail recipes from your bar by using the CLI. Running `php artisan bar:export-recipes {barId}` will generate a .zip file with all cocktail recipes, ingredients and images.

1. Find ID of a bar you want to export recipes from. You can use a basic SQL query to find a list of bars, for example: `sqlite3 storage/bar-assistant/database.ba3.sqlite 'SELECT * FROM bars'`. I'll use `31` as example bar id.
2. If using docker, run `docker compose exec bar-assistant php artisan bar:export-recipes 31`
3. Follow on-screen instructions
4. You can find your .zip file in the volume you mounted: `volume/backups/202312021054_recipes.zip`

## Deleting users (Server)

When a user deletes his account, to keep data integrity, all his account data gets anonymized. If you want to completely delete a user you can use the following command: `php artisan bar:delete-user {email}`. This will delete user and all his data, including cocktails, bars and ingredients he created.
