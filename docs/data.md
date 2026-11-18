---
hide:
  - navigation
---

# Data management

## Choose an export format

All exports are ZIP archives. Recipe-format exports group each cocktail's recipe and available images under `cocktails/<slug>_<id>/`. A datapack also includes supporting bar data for import into another Bar Assistant instance.

| Format | Contents | `type` value |
| --- | --- | --- |
| Datapack | Bar data and images in a format you can import into another instance | `datapack` |
| JSON | Cocktail recipes that follow the [Cocktail JSON schema](https://barassistant.app/cocktail-02.schema.json) | `schema` |
| Markdown | Cocktail recipes in Markdown | `md` |
| XML | Cocktail recipes in XML | `xml` |
| JSON-LD | Cocktail recipes in the [Schema.org Recipe format](https://schema.org/Recipe) | `json-ld` |
| YAML | Cocktail recipes in YAML, with the same fields as the JSON format | `yaml` |

Use `--units` in the CLI or `units` in the API to convert ingredient amounts when conversion is supported. Use `none` to keep the original units. Supported values are `none`, `ml`, `cl`, and `oz`.

## Export data

For the Docker commands below, run them from the `bar-assistant` project directory.

### From the CLI

Run the export command with a bar ID. Replace `123` with your bar's ID.

```bash
docker compose exec bar-assistant php artisan bar:export-recipes 123
```

The command defaults to the `datapack` format. Pass `--type` to choose another format and `--units` to convert supported ingredient amounts.

```bash
docker compose exec bar-assistant php artisan bar:export-recipes 123 --type=md --units=ml
```

Omit the bar ID to search for a bar interactively. Run `docker compose exec bar-assistant php artisan bar:export-recipes --help` to see all options. The command prints the exported file path. Exports are stored under `storage/bar-assistant/exports` in the server container.

### From the API

Send a `POST` request to `/api/exports` with a bearer token. Replace the server URL, token, and bar ID with your values.

```bash
curl --request POST \
  --url 'https://your-server.example/api/exports' \
  --header 'Accept: application/json' \
  --header 'Authorization: Bearer YOUR_TOKEN' \
  --header 'Content-Type: application/json' \
  --data '{"type":"datapack","bar_id":123}'
```

The API returns `202 Accepted` while it creates the archive. Check `GET /api/exports` for the export's `is_done` status. When the export is complete, call `POST /api/exports/{id}/download` to get a download URL.

### From Salt Rim

Open the **Exports** page in Salt Rim settings.

## Import a datapack

The CLI import command accepts Bar Assistant datapack ZIP files. It does not import recipe-only exports such as JSON or Markdown.

Place the ZIP file in `storage/bar-assistant/backups` on the server. In the default Docker setup, this directory is `/var/www/cocktails/storage/bar-assistant/backups` inside the container.

Run the command with a file path relative to `storage/bar-assistant`. For example:

```bash
docker compose exec bar-assistant php artisan bar:import-recipes backups/my-recipes.zip
```

Follow the prompts to choose an existing bar or create a new bar. If you create a bar, enter the owner's user ID. Confirm the import when prompted.

## Create a full backup

Run this command from the `bar-assistant` project directory:

```bash
docker compose exec bar-assistant php artisan bar:full-backup
```

The command prints the backup path. By default, it stores the ZIP archive in `storage/bar-assistant/backups`. The archive contains the SQLite database and uploaded files. Store your environment and deployment configuration separately. The archive does not include Meilisearch indexes.

## Rebuild Meilisearch indexes

Meilisearch indexes are derived from cocktail and ingredient data in the database. After restoring a backup, rebuild the indexes with:

```bash
docker compose exec bar-assistant php artisan bar:refresh-search --clear
```

This command dispatches a queued job. If your queue uses a worker, keep the worker running until the job finishes. Back up any custom Meilisearch API keys separately.

## Delete a user

Deleting an account in Salt Rim anonymizes the account instead of removing its records. To permanently delete a user and the bars, cocktails, ingredients, and images they created, run this command from the `bar-assistant` project directory:

```bash
docker compose exec bar-assistant php artisan bar:delete-user user@example.com
```

The command displays the user details and bar counts, then asks you to confirm. This operation is permanent. Create a full backup first.
