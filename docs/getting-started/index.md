# Installation

This application is made with Laravel, so you should check out [deployment requirements](https://laravel.com/docs/9.x/deployment) for a standard Laravel project.

Specific requirements for Bar Assistant are:

- PHP >= 8.1
    - GD Extension
    - OpCache Extension
    - Redis Extension
    - Zip Extension
- Sqlite 3
- Redis server instance
- Working [Meilisearch server](https://github.com/meilisearch) instance (v0.29)

## With Docker compose <small>recommended</small>

You can get started with the following docker compose file:

``` yml
version: "3"

services:
  meilisearch:
    image: getmeili/meilisearch:v0.29
    environment:
      - MEILI_MASTER_KEY=$MEILI_MASTER_KEY
      - MEILI_ENV=production
    restart: unless-stopped
    volumes:
      - ./meili_data:/meili_data

  redis:
    image: redis
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
    restart: unless-stopped

  bar-assistant:
    image: bar-assistant/server:latest
    environment:
      - APP_URL=http://localhost:3000/bar
      - MEILISEARCH_KEY=$MEILI_MASTER_KEY
      - MEILISEARCH_HOST=http://meilisearch:7700
      - REDIS_HOST=redis
    restart: unless-stopped
    volumes:
      - ./bar:/var/www/cocktails/storage/bar-assistant

  salt-rim:
    image: bar-assistant/salt-rim:latest
    environment:
      - API_URL=http://localhost:3000/bar
    restart: unless-stopped

  webserver:
    image: nginx:alpine
    restart: unless-stopped
    ports:
      - 3000:3000
    volumes:
      - ./nginx.conf:/etc/nginx/conf.d/default.conf
```

And the following nginx configuration:

```conf
server {
    listen 3000 default_server;
    listen [::]:3000 default_server;
    server_name _;

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

## Manual installation

### Meilisearch

Bar Assistant is using Meilisearch as a primary [Scout driver](https://laravel.com/docs/9.x/scout). It's main purpose is to index cocktails and ingredients and power filtering and searching on the frontend. Checkout [this guide here](https://docs.meilisearch.com/learn/cookbooks/docker.html) on how to setup Meilisearch docker instance.

### BA setup

After cloning the repository, you should do the following:

1. Update your environment variables

``` bash
$ cp .env.dist .env
```

``` env
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

2. Run the commands
``` bash
# Install dependecies
$ composer install

# Generate a key
$ php artisan key:generate

# To setup correct image paths
$ php artisan storage:link

# To setup the database:
$ php artisan migrate --force

# To fill the database with data
$ php artisan bar:open

# Or with specific email and password
$ php artisan bar:open --email=my@email.com --pass=12345
```
