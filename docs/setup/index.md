# Installation (Docker)

This is recommended way of installation. This will get you running with the following services:

- Bar Assistant API server
- Salt Rim web client
- Redis service for caching
- Meilisearch service for searching and filtering
- Web server

## Docker Compose &middot; Nginx

Docker compose example repository [can be found here](https://github.com/bar-assistant/docker/).

Docker Compose setup requires a few setup files. First, create the `.env` file and `nginx.conf` files. The .env file will contain your basic configuration variables.

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
    image: getmeili/meilisearch:v1.4 # (2)
    environment:
      - MEILI_MASTER_KEY=$MEILI_MASTER_KEY
      - MEILI_ENV=production
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:7700"]
      interval: 10s
      timeout: 5s
      retries: 5
    volumes:
      - meilisearch_data:/meili_data

  redis:
    image: redis
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 1s
      timeout: 3s
      retries: 30

  bar-assistant:
    image: barassistant/server:v3
    depends_on:
      meilisearch:
        condition: service_healthy
      redis:
        condition: service_healthy
    environment:
      # - PUID=1000 # Optional
      # - PGID=1000 # Optional
      - APP_URL=$API_URL
      - LOG_CHANNEL=stderr # (5)
      - MEILISEARCH_KEY=$MEILI_MASTER_KEY
      - MEILISEARCH_HOST=http://meilisearch:7700 # (1)
      - REDIS_HOST=redis # (4)
      - ALLOW_REGISTRATION=true
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000"]
      interval: 10s
      timeout: 5s
      retries: 5
    volumes:
      - bar_data:/var/www/cocktails/storage/bar-assistant

  salt-rim:
    image: barassistant/salt-rim:v2
    depends_on:
      bar-assistant:
        condition: service_healthy
    environment:
      - API_URL=$API_URL
      - MEILISEARCH_URL=$MEILISEARCH_URL
      - BAR_NAME=$BAR_NAME
      - DESCRIPTION=$BAR_DESCRIPTION
      - DEFAULT_LOCALE=en-US
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8080"]
      interval: 10s
      timeout: 5s
      retries: 5

  webserver:
    image: nginx:alpine
    restart: unless-stopped
    depends_on:
      bar-assistant:
        condition: service_healthy
      salt-rim:
        condition: service_healthy
      meilisearch:
        condition: service_healthy
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

You can put all those files in a single directory, and run the stack with `docker compose up -d`. You can now access the application on URL and port that you defined. By default this will be [localhost:3000](http://localhost:3000).

Please, note that it can sometimes take a minute or more (depending on the hardware) for the server to start. You can check your docker logs (`$ docker compose logs bar-assistant`) for "Application ready" message.

Before you login you need to create a new user, you can do that by click register button.

## Updating

You can update by pulling the newest images and restarting the stack.

``` bash
# Pull images
$ docker compose pull
# Run the stack
$ docker compose up -d
```
