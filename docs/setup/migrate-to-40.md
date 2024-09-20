# Migration - v3.x to v4.0.0

## Prerequisites

- You are on latest v3.x version.
- You have [backups of your data](../faq.md#how-do-i-backup-my-data).


## 1. Update folder permissions

One of the biggest changes in v4.0.0 is that the API docker image is unprivileged by default. This should improve security but comes with some caveats, mostly related to the file permissions. Since now we can't rely on the container to update file permissions in runtime, you will need to manually update the permissions of the files in some cases.

There are two possible scenarios, depending on your setup/preferences, you are using bind mounts or named volumes.

- Bind mounts are local folders that are mounted from the host machine to container (for example: `./local-folder:/var/www/cocktails/storage/bar-assistant`).
- Volumes are named volumes managed by docker (for example: `my-named-volume:/var/www/cocktails/storage/bar-assistant`).

### 1a. Bind mounts

If you are using bind mounts, you need to make sure that the folder is owned by the user that is running the container, in this case `33:33` (www-data).

For the following example setup: `./local-folder:/var/www/cocktails/storage/bar-assistant`, you would run the following command on your host machine:

``` bash
# Update local folder permissions, may require sudo
$ chown -R 33:33 ./local-folder
```

If you are using rootless docker this get a bit more complicated. You need to find what the pid and gid of the user inside the container is. And then you need to `chown` the folder to that user. In most cases this will be `100032:100032` but it can vary depending on your docker setup. Learn more about this [here](https://docs.docker.com/engine/security/userns-remap/).

### 1b. Volumes

To change the permissions for bar-assistant folder in a named volume, you need to run the following command:

``` bash
docker compose exec bar-assistant chown -R 33:33 storage/bar-assistant
```

## 2. Update default port

Bar Assistant container now exposes port `8080` instead of `3000`. So you need to update your nginx config. Find the line that sets the Bar Assistant proxy pass in your `nginx.conf` and change it to:

``` hl_lines="2"
location /bar/ {
    proxy_pass http://bar-assistant:8080/;
}
```

## 3. Update docker compose

Update the docker compose file to use the new images:

``` yaml
# For bar assistant server
image: barassistant/server:{++v4++}
# For salt rim
image: barassistant/salt-rim:{++v3++}
```

Then pull and restart the stack:

``` bash
$ docker compose pull
$ docker compose up -d
```

!!! tip

    Please note that you will need to clear your site cache and logout for the frontend to refresh properly.

## 4. Other changes

The following ENV variables are not required anymore, and can be safely removed from your docker-compose file: `LOG_CHANNEL`, `DEFAULT_LOCALE`.

Also, redis is now optional (but recommended) service, check the [installation](../index.md) docs for more information.
