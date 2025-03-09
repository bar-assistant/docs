# Installation (Docker)

This is recommended way of installation. This will get you running with the following services:

- Bar Assistant API server
- Salt Rim web client
- Meilisearch service for searching and filtering
- Optional Redis service for caching and sessions
- Optional web server used as a reverse proxy

## Docker Compose &middot; Nginx

Docker compose example repository [can be found here](https://github.com/bar-assistant/docker/).

Docker Compose setup requires a few setup files. First, create the `.env` file and `nginx.conf` files. The .env file will contain your basic configuration variables.

```properties title=".env"
# Your Meilisearch master key
# Find out more here: https://docs.meilisearch.com/learn/getting_started/quick_start.html#securing-meilisearch
MEILI_MASTER_KEY=masterKey-make-it-long-for-security

# Base URL of the application
# You should update this value to the URL you plan to use (ex: http://192.168.100.100, https://my-personal-bar.com)
# The value MUST be without trailing slash
BASE_URL=http://localhost:3000

# Meilisearch server instance URL, change if you are using different host from base url, otherwise leave as default
# Must be accessible from your browser
MEILISEARCH_URL=${BASE_URL}/search

# Bar Assistant server instance URL, change if you are using different host from base url, otherwise leave as default
# Must be accessible from your browser
API_URL=${BASE_URL}/bar
```

And here are the contents of nginx configuration. In short, this exposes the Bar Assistant API server on `example.com/bar/` path, Meilisearch on `example.com/search/` and frontend client on `example.com`.

```nginx title="nginx.conf"
server {
    listen 3000 default_server;
    listen [::]:3000 default_server;
    server_name _;

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    client_max_body_size 100M;

    location /bar/ {
        proxy_pass http://bar-assistant:8080/;
    }

    location /search/ {
        proxy_pass http://meilisearch:7700/;
    }

    location / {
        proxy_pass http://salt-rim:8080/;
    }
}
```

Then create `docker-compose.yml` file with the following contents.

```yaml title="docker-compose.yml"
volumes:
  bar_data:
  meilisearch_data:

services:
  meilisearch:
    image: getmeili/meilisearch:v1.8 # Never use latest tag
    environment:
      - MEILI_MASTER_KEY=$MEILI_MASTER_KEY
      - MEILI_ENV=production
    restart: unless-stopped
    volumes:
      - meilisearch_data:/meili_data

  # Optional, but recommended
  redis:
    image: redis
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
    restart: unless-stopped

  bar-assistant:
    image: barassistant/server:v4
    depends_on:
      - meilisearch
      - redis # Remove if not using redis
    environment:
      - APP_URL=$API_URL
      - MEILISEARCH_KEY=$MEILI_MASTER_KEY
      - MEILISEARCH_HOST=http://meilisearch:7700 # This needs to be host that can be resolved from inside the container.
      - REDIS_HOST=redis # Remove if not using redis
      - CACHE_DRIVER=redis # Change to "file" if not using redis
      - SESSION_DRIVER=redis # Change to "file" if not using redis
      - ALLOW_REGISTRATION=true
    restart: unless-stopped
    volumes:
      - bar_data:/var/www/cocktails/storage/bar-assistant

  salt-rim:
    image: barassistant/salt-rim:v3
    depends_on:
      - bar-assistant
    environment:
      - API_URL=$API_URL
      - MEILISEARCH_URL=$MEILISEARCH_URL
    restart: unless-stopped

  # Reverse proxy all web services
  # API, Salt-Rim and Meilisearch containers must be accesible from your browser
  # You can remove this service if you already have a reverse proxy somewhere in your stack,
  # but you will need to manually setup the configuration
  # Check included nginx.conf for reference
  webserver:
    image: nginx:alpine
    restart: unless-stopped
    depends_on:
      - bar-assistant
      - salt-rim
      - meilisearch
    ports:
      - 3000:3000
    volumes:
      - ./nginx.conf:/etc/nginx/conf.d/default.conf
```

!!! info

    If you want to use a bind mounts, you need to make sure that the folder is owned by the user that is running the container, in this case `33:33` (www-data). You can do this by running `chown -R 33:33 /path/to/folder` and then restarting the container.

!!! warning

    If you are using rootless docker and want to use bind mounts, you will need to manually set the correct user permissions on your host folder. In most cases this will be `100032:100032` but it can vary depending on your docker setup. Learn more about this [here](https://docs.docker.com/engine/security/userns-remap/).

You can put all those files in a single directory, and run everything with `docker compose up -d`. You can now access the application on URL and port that you defined. By default this will be [localhost:3000](http://localhost:3000).

Please, note that it can sometimes take a minute or more (depending on the hardware) for the server to start. You can check your docker logs (`$ docker compose logs bar-assistant`) for "Application ready" message.

Before you login you need to create a new user, you can do that by clicking register button.

## Container images

Bar Assistant is available as a Docker image on [Docker Hub](https://hub.docker.com/r/barassistant/server) and [GitHub Container Registry](https://github.com/karlomikus/bar-assistant/pkgs/container/barassistant). There is no `latest` tag, so you need to specify version in the tag. For example:

- `barassistant/server:v4.4.1` - This will pull the exact version
- `barassistant/server:v4.4` - This will pull the latest minor release
- `barassistant/server:v4` - This will pull the latest major release
- `barassistant/server:dev` - This will pull the latest development release (unstable)

## Updating

You can update by pulling the newest images and restarting the stack.

``` bash
# Pull images
$ docker compose pull
# Run the stack
$ docker compose up -d
```

## More reverse proxy examples

If you already have a reverse proxy setup, you can exclude the webserver service and adapt the following examples.

### Setup with custom subdomain

Here's an example of how to setup Bar Assistant on `bar.mydomain.com` with your existing nginx as a reverse proxy. In your existing nginx config, add another server block like the following.

```nginx title="nginx.conf"
# This assumes that your proxy service is capable of resolving the container hostnames
server {
    server_name bar.mydomain.com;

    location /bar/ {
        proxy_pass http://bar-assistant:8080/;
    }

    location /search/ {
        proxy_pass http://meilisearch:7700/;
    }

    location / {
        proxy_pass http://salt-rim:8080/;
    }
}
```

### Nginx config example with multiple subdomains

Here's an example similar to our cloud instance setup, where Bar Assistant API is exposed on api subdomain and Meilisearch on search subdomain.

```nginx title="nginx.conf"
# This assumes that your proxy service is capable of resolving the container hostnames
server {
  server_name api.example.com;

  location / {
    proxy_pass http://bar-assistant:8080/;
  }
}
server {
  server_name search.example.com;

  location / {
    proxy_pass http://meilisearch:7700/;
  }
}
server {
  server_name my-bar.example.com;

  location / {
    proxy_pass http://salt-rim:8080/;
  }
}
```

### Caddy config example

This is an example of Caddyfile for default configuration.

``` caddyfile title="Caddyfile"
# This assumes that your proxy service is capable of resolving the container hostnames
mydomain.com {
    handle_path /bar/* {
        reverse_proxy bar-assistant:3000
    }

    handle_path /search/* {
        reverse_proxy meilisearch:7700
    }

    handle_path /* {
        reverse_proxy salt-rim:8080
    }
}
```
