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