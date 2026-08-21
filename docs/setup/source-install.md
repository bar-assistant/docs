# Installation (Source)

Please note, you should be familiar with linux server setup.

Bar Assistant is made with [Laravel](https://laravel.com), you can check out [default laravel requirements here](https://laravel.com/docs/deployment). A few extra prerequisites are:

- You have `git` installed
- You have installed PHP >= 8.4 with the following extensions:
    - ffi
    - opcache
    - redis
    - zip
    - sqlite
    - bcmath
    - intl
- You have the `libvips42` system package installed (required for image processing via the `jcupitt/vips` FFI bindings). Without it, image uploads will fail silently or crash.
- Your `php.ini` has the following settings (required by the libvips FFI bindings):
    - `ffi.enable=true`
    - `zend.max_allowed_stack_size=-1`
- You have [Composer](https://getcomposer.org) installed
- You have `sqlite3` installed
- You have meilisearch running somewhere.
- (Optional) You have Redis server instance running

### 1. Setup the API

Clone the [bar-assistant](https://github.com/karlomikus/bar-assistant) repository and create `.env` file.

``` bash
$ cp .env.dist .env
```
Update the required variables:

``` env title=".env"
# Your application instance URL
APP_URL=

# Database
DB_CONNECTION=sqlite
DB_FOREIGN_KEYS=true

# Redis
REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379
CACHE_DRIVER=redis
SESSION_DRIVER=redis

# Search
SCOUT_DRIVER=meilisearch
MEILISEARCH_HOST=
MEILISEARCH_KEY=
```

### 2. Install dependencies

Use [Composer](https://getcomposer.org) to install the required dependencies.

``` bash
# Install dependecies
$ composer install --optimize-autoloader --no-dev
```

### 3. Setup the rest of the application

Now you should be able to use `artisan` commands to setup the rest of the application.

``` bash
# Create the storage directories required by the application
mkdir -p storage/bar-assistant/uploads/cocktails
mkdir -p storage/bar-assistant/uploads/ingredients
mkdir -p storage/bar-assistant/uploads/temp
mkdir -p storage/bar-assistant/backups
touch storage/bar-assistant/database.ba3.sqlite

# Generate a key
php artisan key:generate

# To setup the database:
php artisan migrate --force

# To setup correct image paths
php artisan storage:link

# Clear config cache so new ENV settings get picked up
php artisan config:clear

# Setup search engine
php artisan bar:setup-meilisearch
php artisan scout:sync-index-settings

# Warmup cache
php artisan config:cache
php artisan route:cache
php artisan event:cache

# Clear expired tokens
php artisan sanctum:prune-expired --hours=24

# Sync base recipes
git clone --depth 1 --branch v5 https://github.com/bar-assistant/data.git resources/data

# Publish the immutable starter-media release before provisioning bars
php artisan starter-media:publish

# Verify the installation
php artisan about
```

The starter-media command stores release-versioned images in `storage/bar-assistant/catalog`. Keep this directory with the database and uploads during upgrades and backups; it retains the media used by existing bars. Run the publish command after updating `resources/data` and before starting workers that provision or synchronize bars. It is idempotent for an unchanged release and rejects changed media published under the same release version.

If you want to run background jobs (bar setup, recipe imports, search indexing), start a queue worker after publishing starter media. The application uses [Laravel Horizon](https://laravel.com/docs/horizon):

``` bash
php artisan horizon
```

You can now configure your webserver to serve the PHP files from the `public` folder. An [example config with ngnix is available here](https://laravel.com/docs/deployment#nginx).

### 4. Install web client

After cloning the Salt Rim repository do the following.

1. Install dependencies with `bun install` (requires Bun, or use `npm install` — requires Node `^22.18.0 || >=24.12.0`)
2. Add a config file to public folder: `public/config.js`
```js
window.srConfig = {}
window.srConfig.API_URL = "http://my-bar.com"
window.srConfig.MEILISEARCH_URL = "http://my-milisearch.com"
```
3. Build for production by running `bun run build` (or `npm run build`)
4. Now you have a `dist/` folder. You can configure your webserver to serve static files from this folder.
