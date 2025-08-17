# Installation (Docker)

This is recommended way of installation. This will get you running with the following services on your localhost:

- Bar Assistant API server
- Salt Rim web client
- Meilisearch service for searching and filtering
- Optional Redis service for caching and sessions

## Docker Compose

Docker compose example repository [can be found here](https://github.com/bar-assistant/docker/).

### Step 1: Create required files

Docker Compose setup requires a few setup files. First, create the `.env` file and `docker-compose.yml` files. The .env file will contain your basic configuration variables.

```properties title=".env"
# Your Meilisearch master key (https://docs.meilisearch.com/learn/getting_started/quick_start.html#securing-meilisearch)
MEILI_MASTER_KEY=masterKey-make-it-long-for-security

# Web client URL
BASE_URL=http://localhost:8080

# Meilisearch server instance URL
MEILISEARCH_URL=http://localhost:8081

# Bar Assistant server instance URL
API_URL=http://localhost:8082
```

Then in your `docker-compose.yml` copy and paste the following.

```yaml title="docker-compose.yml"
volumes:
  bar_data:
  meilisearch_data:

services:
  meilisearch:
    image: getmeili/meilisearch:v1.15 # Never use latest tag
    environment:
      - MEILI_NO_ANALYTICS=true
      - MEILI_MASTER_KEY=$MEILI_MASTER_KEY
      - MEILI_ENV=production
    restart: unless-stopped
    volumes:
      - meilisearch_data:/meili_data
    ports:
      - "8081:7700"

  # Optional, but recommended
  redis:
    image: redis
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
    restart: unless-stopped

  bar-assistant:
    image: barassistant/server:v5
    depends_on:
      - meilisearch
      - redis # Remove if not using redis
    environment:
      - APP_URL=$API_URL
      - MEILISEARCH_KEY=$MEILI_MASTER_KEY
      - MEILISEARCH_HOST=http://meilisearch:7700
      - REDIS_HOST=redis # Remove if not using redis
      - CACHE_DRIVER=redis # Change to "file" if not using redis
      - SESSION_DRIVER=redis # Change to "file" if not using redis
      - ALLOW_REGISTRATION=true
    restart: unless-stopped
    ports:
      - "8082:8080"
    volumes:
      - bar_data:/var/www/cocktails/storage/bar-assistant

  salt-rim:
    image: barassistant/salt-rim:v4
    depends_on:
      - bar-assistant
    environment:
      - API_URL=$API_URL
      - MEILISEARCH_URL=$MEILISEARCH_URL
    restart: unless-stopped
    ports:
      - "8080:8080"
```

!!! info

    If you want to use a bind mounts, you need to make sure that the folder is owned by the user that is running the container, in this case `33:33` (www-data). You can do this by running `chown -R 33:33 /path/to/folder` and then restarting the container.

!!! warning

    If you are using rootless docker and want to use bind mounts, you will need to manually set the correct user permissions on your host folder. In most cases this will be `100032:100032` but it can vary depending on your docker setup. Learn more about this [here](https://docs.docker.com/engine/security/userns-remap/).

### Step 2: Run the stack

Once you have all those files in a directory, you can run everything with `docker compose up -d`. After everything is up and running you can now access the browser client on URL and port that you defined. By default this will be [localhost:8080](http://localhost:8080).

Please, note that it can sometimes take a minute or more (depending on the hardware) for the server to start. You can check your docker logs (`$ docker compose logs bar-assistant`) for "Application ready" message.

Before you login you need to create a new user, you can do that by clicking register button.

## Container images

Bar Assistant is available as a Docker image on [Docker Hub](https://hub.docker.com/u/barassistant) and [GitHub Container Registry](https://github.com/karlomikus?tab=packages). There is no `latest` tag, so you need to specify version in the tag. For example:

- `barassistant/server:v4.4.1` - This will pull the exact version
- `barassistant/server:v4.4` - This will pull the latest minor release
- `barassistant/server:v4` - This will pull the latest major release
- `barassistant/server:dev` - This will pull the latest development release (unstable and not recommended)

## Updating

You can update by pulling the newest images and restarting the stack.

``` bash
# Pull images
$ docker compose pull
# Run the stack
$ docker compose up -d
```

## Reverse proxy configuration

Currently the setup requires that you proxy 3 services. This can be done with Nginx, Caddy, or any other reverse proxy server. Don't forget to update your `.env` file with the correct URLs.

### Nginx config example with subfolders

Here's an example of how to setup nginx configuration that will expose the services as subfolders of your domain. This is useful if you want to run multiple services on the same domain.

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

### Nginx config example with subdomains

Here's an example of how to setup nginx configuration that will expose the services as subdomains of your domain. This is useful if you want to run each service on a separate subdomain.

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

### Caddy config example with subdomains

This is an example of Caddyfile configuration that will expose the services as subdomains of your domain. Caddy is a modern web server that automatically handles HTTPS for you.

``` caddyfile title="Caddyfile"
# This assumes that your proxy service is capable of resolving the container hostnames
api.example.com {
    reverse_proxy bar-assistant:8080
}
search.example.com {
    reverse_proxy meilisearch:7700
}
my-bar.example.com {
    reverse_proxy salt-rim:8080
}
```
