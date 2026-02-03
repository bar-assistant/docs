---
hide:
  - navigation
---

# Usage

Here you can find some information about using some of the Bar Assistant features.

## Installation

Visit [setup page](setup/index.md) to view installation steps.

## Initial bar data

When you create a new bar, you can choose to start a bar with cocktails and ingredients already included. All that initial data is managed in a separate repository and pulled when building a Docker image. You can view and contribute to that data via the [Bar Assistant Public Data repository](https://github.com/bar-assistant/data). The standard recipe repository usually gets updates with new recipes. To pull new recipes, you can go to "Bars" -> "Edit bar" and click on "Synchronize data".

## Managing ingredients

You can manage all ingredients via the "Ingredients" page. Any ingredient that you create can be added as a child ingredient to another ingredient. This way you can create a hierarchy of ingredients that can be used for matching ingredients in cocktail recipes. So for example if you have "Lemon Juice" as a child ingredient of "Citrus Juice", any cocktail that requires "Citrus Juice" will match "Lemon Juice" as well.

You can also create "Complex ingredients" which are ingredients made up of other ingredients. For example "Simple Syrup" can be made up of "Sugar" and "Water", so when you add "Sugar" and "Water" to your shelf you will be able to make cocktails that require "Simple Syrup".

## Showing what recipes you can make

All cocktails that you can make and ingredients that you have are managed via "Shelf". To see what recipes you can make you need to add all ingredients that you have to your shelf. There are two shelf variants that you can match ingredients against. The "Bar shelf" is shared among all bar members and managed by bar admins/moderators. The "Personal shelf" is only for you and you can manage it yourself.

To add ingredients to your shelf follow these steps:

1. Go to "Ingredients" page
2. Search or create an ingredient that you want to add to your shelf
3. Click "Add to shelf" action
4. Go to "Cocktails" page
5. In filters check "Cocktails I can make" checkbox

### Controlling ingredient matching

You can increase your available cocktail recipes in a few ways.

- You can edit cocktail recipes to include substitutes for specific ingredients. So if you have any of the substitute ingredients they will show up in your shelf.
- Enabling "Make this ingredient optional" on specific ingredient in cocktail recipe will make that ingredient not required for matching. This way you can make cocktails even if you are missing some ingredients.
- Enabling "Use this specific ingredient" will make sure that only that specific ingredient is used for matching and any variants or child ingredients will be ignored.

## Adding recipes

You can create new cocktail recipes by clicking the "Create cocktail" button on the "Cocktails" page. From that page you can manage all data related to the recipe, including ingredients, tags, images, and more.

You can also import recipes from various sources. If you are missing some import options, you can open a [GitHub issue](https://github.com/karlomikus/bar-assistant) and describe what you would want to be added.

### Import from website

With Bar Assistant, you can scrape cocktail recipes directly from the given webpage. Some websites are officially supported, but Bar Assistant will try to extract recipe data from any link you give it.

After you import the recipe from the URL, you will be presented with all the data that was found. Here you can double-check if everything is correct and keep it in sync with your data. Ingredients will be automatically matched by their name; if the ingredient is not found, it will be created. You can also manually match ingredients.

## Recipe collections

You can create a recipe collection in a few ways.

By manually creating collections via the "Collections" page. Then you can go to a single cocktail recipe and in the actions dropdown select "Add to collection". You can also create a new collection directly from the dialog that shows up.

To add multiple recipes to a collection, you can use the "Cocktails" page to filter what cocktails you want to add and then click the "Add to collection" button in the top right.

If you want to share your collection with all the members in the bar, you can enable that on the "Collections" page when you edit a specific collection. All shared collections will be shown in the filter sidebar of the "Cocktails" page.

## Searching and filtering

Finding the perfect drink shouldn't be harder than drinking it. You can use global search that is always available when you click "Search" in site header. This search will look through all cocktails and ingredients in the bar.

When you're on the main Cocktails page, you can drill down into your library using these specific facets:

|Filter|Description|
|-|-|
| Bar shelf cocktails | Cocktails you can make with ingredients from the bar shelf.|
| Locked bar cocktails | Cocktails that are not available to make because of missing ingredients in the bar shelf.|
| Cocktails I can make | Cocktails you can make with ingredients from your personal shelf.|
|Cocktails I can't make| Cocktails that are not available to make because of missing ingredients in your personal shelf.|
| My favorites| Cocktails you've marked as favorites.|
|Public cocktails| Cocktails that have a public link.|
| Specified ingredients | This will show you cocktails that have all the selected ingredients in the recipe.|
| Ignored ingredients | This will show you cocktails that don't have any of the selected ingredients in the recipe.|
| Collections | This will show you cocktails that are part of the selected collections. This will also show collections from other bar members if they are shared.|
| Recipes by user | This will show you cocktails that were added by the selected users.|
| Main ingredient | This will show you cocktails that have the selected ingredient as the main ingredient in the recipe.|
| Method | This will show you cocktails that use the selected preparation method.
| Strength | This will show you cocktails that fall into the selected strength by ABV range.|
| Tags | This will show you cocktails that have the selected custom tags.| 
| Glass type | This will show you cocktails that are served in the selected glass type.|
| Total ingredients | This will show you cocktails that have the selected total number of ingredients in the recipe.|
| Missing ingredients (Bar) | This will show you cocktails that are missing the selected number of ingredients from the bar shelf.|
| Missing ingredients (Shelf) | This will show you cocktails that are missing the selected number of ingredients from your personal shelf.|
| Your rating | This will show you cocktails that you have rated with the selected rating.|
| Average rating | This will show you cocktails that have the selected average rating from all bar members.|

When you're on the main Ingredients page, you can drill down into your library using these specific facets:

|Filter|Description|
|-|-|
| Bar shelf ingredients | Ingredients that are on the bar shelf.|
| Shelf ingredients | Ingredients that are on your personal shelf.|
| Shopping list ingredients | Ingredients that are on your shopping list.|
| Used as main ingredient | Ingredients that are used as main ingredient in any cocktail recipe.|
| Complex ingredient | Ingredients that are complex ingredients (made up of other ingredients).|
| Category | Ingredients that belong to the selected category.|
| Strength | Ingredients that fall into the selected strength by ABV range.|

## Sharing recipes

Bar Assistant allows you to share recipes in a few ways. All actions are available on a specific cocktail recipe page.

- Print recipe: This shows you a print-friendly page with the recipe information.
- Create a public link: This will create a public link that you can share with your friends.
- Generate recipe image: Create a recipe image that you can share with your friends.
- Copy as JSON: This will copy the recipe in a specific format that you can use to import it into another bar.
- Copy as YAML/XML/Markdown/JSON-LD: This will copy recipe information in the selected format.

## User roles

In Bar Assistant, permissions flow from the top down. Higher roles generally inherit the abilities of the roles below them.

| Role | Access Level | Primary Purpose |
| --- | --- | --- |
| **Bar Owner** | **Absolute** | Creator of the bar; ultimate authority. |
| **Admin** | **High** | Full bar management (except deletion). The "Superuser." Admins can perform almost any action within a bar, from managing members to editing all content. |
| **Moderator** | **Medium** | Content management and basic bar settings. This is the standard active role for users who want to add to the bar's library. |
| **General** | **Standard** | Active contributors (recipes and ingredients). |
| **Guest** | **Low** | Read-only access with personal interactions. The "Consumer." Ideal for users who only need to browse the bar. |

!!! warning

    Keep in mind that the user that created the bar can delete it at any point (independent of the role he has). Deleting the bar also deletes all the recipes and ingredients that members added.

### Access Control Matrix

**Legend:** ✅ Full Access | 👤 Self/Author Only | 👥 Members Only | 🌐 Everyone (Registered)

| Entity / Action | Admin | Moderator | Owner | Author | Member | Registered |
| --- | --- | --- | --- | --- | --- | --- |
| **Bar** |  |  |  |  |  |  |
| Create |  |  |  |  |  | ✅ |
| View | ✅ | ✅ | ✅ |  | ✅ |  |
| Edit / Remove Members | ✅ |  | ✅ |  |  |  |
| Delete / Deactivate / Export |  |  | ✅ |  |  |  |
| Manage Shelf | ✅ | ✅ | ✅ |  |  |  |
| **Cocktails & Ingredients** |  |  |  |  |  |  |
| Create | ✅ | ✅ |  |  |  | ✅ |
| View | ✅ | ✅ | ✅ |  | ✅ |  |
| Edit / Delete | ✅ | ✅ |  | 👤 |  |  |
| Create Public Link | ✅ | ✅ |  | 👤 |  |  |
| Rate / Add Notes |  |  |  |  | ✅ |  |
| **System Data** (Methods, Tags, etc.) |  |  |  |  |  |  |
| Create / Edit / Delete | ✅ | ✅ |  |  |  |  |
| View | ✅ | ✅ | ✅ |  | ✅ |  |
| **Users** |  |  |  |  |  |  |
| Create / View / Edit | ✅ | ✅ |  |  |  |  |
| Delete Account |  |  |  |  |  | 👤 |
