# Installation (Source)

Please note, you should be familiar with linux server setup.

Bar Assistant is made with [Laravel](https://laravel.com), you can check out [default laravel requirements here](https://laravel.com/docs/deployment). A few extra prerequisites are:

- You have `git` installed
- You have installed PHP >= 8.3 with the following extensions:
    - ffi
    - opcache
    - redis
    - zip
    - sqlite
    - bcmath
    - int
- You have [Composer](https://getcomposer.org) installed
- You have `sqlite3` installed
- (Optional) You have Redis server instance running
- (Optional) You have one of the supported [search](https://laravel.com/docs/scout) servers.

After cloning the repository, do the following:

### 1. Setup your environment variables

Create `.env` file.

``` bash
$ cp .env.dist .env
```
Update the required variables:

``` env title=".env"
# Your application instance URL
APP_URL=
REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379
CACHE_DRIVER=redis
SESSION_DRIVER=redis
```

### 2. Install dependencies

Use [Composer](https://getcomposer.org) to install the required dependencies.

``` bash
# Install dependecies
$ composer install
```

### 3. Setup the rest of the application

``` bash
# Generate a key
$ php artisan key:generate

# Create a database file
$ touch storage/bar-assistant/database.ba3.sqlite

# To setup the database:
$ php artisan migrate --force

# To setup correct image paths
$ php artisan storage:link

# Setup search engine
$ php artisan bar:setup-meilisearch
$ php artisan scout:sync-index-settings

# Warmup cache
$ php artisan config:cache
$ php artisan route:cache
$ php artisan event:cache
```

You can now configure your webserver to serve the PHP files from the `public` folder. An [example config with ngnix is available here](https://laravel.com/docs/deployment#nginx).

### 4. Install web client

After cloning the Salt Rim repository do the following.

1. Install dependencies with `npm install`
2. Add a config file to public folder: `public/config.js`
```js
window.srConfig = {}
window.srConfig.API_URL = "http://my-bar.com"
window.srConfig.MEILISEARCH_URL = "http://my-milisearch.com"
```
3. Build for production by running `npm run build`
4. Now you have a `dist/` folder. You can configure your webserver to serve static files from this folder.
