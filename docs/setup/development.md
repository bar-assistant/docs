# Development setup

The easiest way to setup your development environment is with Docker. Bar Assistant repository comes with development `docker-compose.yml` file.

1. Clone the repository
2. Copy `.env.dev` as `.env`, or setup your own env file
3. Run `docker compose up -d`
4. Run the following commands to get the app running:
```bash
$ touch storage/bar-assistant/database.ba3.sqlite
$ docker compose exec app composer install
$ docker compose exec app php artisan key:generate
$ docker compose exec app php artisan storage:link
$ docker compose exec app php artisan migrate
```
5. (Optional) Add bar data
``` bash
$ git clone https://github.com/bar-assistant/data.git resources/data
```

## Starter media catalog

Starter data lives in `resources/data`. Its JSON files describe cocktails, ingredients, glasses, and their image paths. The media itself is published separately to the local catalog disk at `storage/bar-assistant/catalog`, so each bar can reference the same starter image instead of storing a duplicate upload.

The source-data disk contains `data/starter-media-release.json`. Its `version` identifies an immutable starter-media release. Before provisioning a bar or running starter-data synchronization, publish the checked-out release:

```bash
$ docker compose exec app php artisan starter-media:publish
```

The command discovers every image referenced by starter data and streams it to `catalog/<version>/...`. Once every object is present and its checksum has been verified, it writes `catalog/<version>/completion-manifest.json`. This completion manifest prevents provisioning from creating image attachments for a partially uploaded catalog release.

Re-running the command for unchanged source data is safe. If an image changes, update the release version in `starter-media-release.json` before publishing: an existing completed version cannot be overwritten. Old catalog releases remain in storage because existing bars may still reference their images.

For local development, run the publish command after cloning or updating `resources/data`, and before creating a bar with starter data or running starter-data synchronization. The development Docker Compose setup bind-mounts the repository, so the catalog persists in your working tree under `storage/bar-assistant/catalog` until you remove it.

## Code quality

The following commands should all pass before you push the changes:

```bash
# Run checkstyle
$ docker compose exec app composer fix-style
# Run PHPStan checks
$ docker compose exec app composer static
# Run the test suite
$ docker compose exec app php artisan test
```
