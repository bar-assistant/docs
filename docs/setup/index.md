# Installation

Bar Assistant API is made with PHP and Laravel framework. It is using Meilisearch as a primary [Scout driver](https://laravel.com/docs/scout). It's main purpose is to index cocktails and ingredients and power filtering and searching on the frontend. Checkout [this guide here](https://docs.meilisearch.com/learn/cookbooks/docker.html) on how to setup Meilisearch docker instance.

Salt Rim is official web client for Bar Assistant made with Vue.js 3.

Bar Assistant has official [docker image available here](https://hub.docker.com/u/barassistant). Docker compose example repository [can be found here](https://github.com/bar-assistant/docker/).

The recommended way of installation for the most people is with docker containers.

## Quick setup with Docker compose

!!! warning

    If you are planning to use a local folder as a volume, you will need to create it first and give it correct permissions before running docker compose commands.
    ```bash
    $ mkdir my-bar-data
    $ sudo chown 33:33 my-bar-data
    ```

First, create the `.env` file and `nginx.conf` files. The .env file will contain your basic configuration variables.

```properties title=".env"
# Your Meilisearch master key
# Find out more here: https://docs.meilisearch.com/learn/getting_started/quick_start.html#securing-meilisearch
MEILI_MASTER_KEY=masterKey-make-it-long-for-security

# Base URL of the application
# You should update this value to the one you are using (ex: http://192.168.100.100, https://my-personal-bar.com)
# In this case it's the URL and port that is exposed in webserver service
# The value MUST be without trailing slash
BASE_URL=http://localhost:3000

# Meilisearch server instance URL, change if you are using different host from base url, otherwise leave as default
MEILISEARCH_URL=${BASE_URL}/search

# Bar Assistant server instance URL, change if you are using different host from base url, otherwise leave as default
API_URL=${BASE_URL}/bar

# (Optional) Bar name
BAR_NAME=

# (Optional) Short bar description
BAR_DESCRIPTION=
```

And here are the contents of nginx configuration.

```nginx title="nginx.conf"
server {
    listen 3000 default_server;
    listen [::]:3000 default_server;
    server_name _;

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    client_max_body_size 100M;

    location /bar/ {
        proxy_pass http://bar-assistant:3000/;
    }

    location /search/ {
        proxy_pass http://meilisearch:7700/;
    }

    location / {
        proxy_pass http://salt-rim:8080/;
    }
}
```

!!! tip

    These `proxy_pass` URLs are related to container hostnames that docker compose automatically creates inside it's default network.
    If you renamed services inside your compose file you will have to also update these values.

Then create `docker-compose.yml` file with the following contents.

```yaml title="docker-compose.yml"
version: "3"

services:
  meilisearch:
    image: getmeili/meilisearch:v1.1 # (2)
    environment:
      - MEILI_MASTER_KEY=$MEILI_MASTER_KEY
      - MEILI_ENV=production
    restart: unless-stopped
    volumes:
      - meilisearch_data:/meili_data

  redis:
    image: redis
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
    restart: unless-stopped

  bar-assistant:
    image: barassistant/server:latest
    depends_on:
      - meilisearch
      - redis
    environment:
      - APP_URL=$API_URL
      - LOG_CHANNEL=stderr # (5)
      - MEILISEARCH_KEY=$MEILI_MASTER_KEY
      - MEILISEARCH_HOST=http://meilisearch:7700 # (1)
      - REDIS_HOST=redis # (4)
      - ALLOW_REGISTRATION=true
    restart: unless-stopped
    volumes:
      - bar_data:/var/www/cocktails/storage/bar-assistant

  salt-rim:
    image: barassistant/salt-rim:latest
    depends_on:
      - bar-assistant
    environment:
      - API_URL=$API_URL
      - MEILISEARCH_URL=$MEILISEARCH_URL
      - BAR_NAME=$BAR_NAME
      - DESCRIPTION=$BAR_DESCRIPTION
      - DEFAULT_LOCALE=en-US
    restart: unless-stopped

  webserver:
    image: nginx:alpine
    restart: unless-stopped
    ports:
      - 3000:3000 # (6)
    volumes:
      - ./nginx.conf:/etc/nginx/conf.d/default.conf # (3)

volumes:
  bar_data:
  meilisearch_data:
```

1. This is container name that automatically gets setup in docker compose network.
2. You should always use a specific Meilisearch version instead of latest tag.
3. Make sure you have correctly configured nginx config location.
4. Like Meilisearch above, this is using docker compose hostname as server host.
5. This will log application errors to your docker logs.
6. The port with which you will access the frontend.

This will get you running with the following services:

- Bar Assistant API server
- Salt Rim web client
- Redis service for caching
- Meilisearch service for searching and filtering
- Nginx as a default web server service

You can put all those files in a single directory, and run the stack with `docker compose up -d`. You can now access the application on URL and port that you defined. By default this will be [localhost:3000](http://localhost:3000).

Please, note that it can sometimes take a minute or more (depending on the hardware) for the server to start. You can check your docker logs (`$ docker compose logs bar-assistant`) for "Application ready" message.

Default email and password are:

- Email: `admin@example.com`
- Password: `password`

## Manual installation

Please note, you should be familiar with linux server setup.

Bar Assistant is made with [Laravel](https://laravel.com), you can check out [default laravel requirements here](https://laravel.com/docs/9.x/deployment). A few extra prerequisites are:

- You have installed PHP >= 8.1 with required extensions:
    - GD Extension
    - OPCache Extension
    - Redis Extension
    - Zip Extension
- You have [Composer](https://getcomposer.org) installed
- You have Sqlite3 installed
- You have Redis server instance running
- You have empty [Meilisearch server](https://github.com/meilisearch) instance (>=v1.0)
- You have `git` installed

After cloning the repository, do the following:

### 1. Setup your environment variables

Create your `.env` file.

``` bash
$ cp .env.dist .env
```
The following variables are required:

``` env title=".env"
# Your application instance URL
APP_URL=
# Meilisearch instance URL
MEILISEARCH_HOST=
# Meilisearch search key
MEILISEARCH_KEY=
# If using redis, the following
REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379
CACHE_DRIVER=redis
SESSION_DRIVER=redis
```

### 2. Install dependencies

Use composer to install the required dependencies.

``` bash
# Install dependecies
$ composer install
```

### 3. Setup the rest of the application

``` bash
# Generate a key
$ php artisan key:generate

# To setup correct image paths
$ php artisan storage:link

# To setup the database:
$ php artisan migrate --force

# To fill the database with data
$ php artisan bar:open
```

You can now configure your webserver to serve the PHP files from the `public` folder.

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

## Development environment

The easiest way to setup your development environment is with Docker. Bar Assistant repository comes with development `docker-compose.yml` file.

1. Clone the repository
2. Copy `.env.dev` as `.env`, or setup your own env file
3. Run `docker compose up -d`
4. Run the following commands to get the app running:
```bash
$ docker compose exec app composer install
$ docker compose exec app php artisan key:generate
$ docker compose exec app php artisan storage:link
$ docker compose exec app php artisan migrate
$ docker compose exec app php artisan bar:open
```
