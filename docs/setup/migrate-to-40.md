# Migration - v3.x to v4.0.0

If you are using docker compose this process is really simple.

First make sure you are on latest v3.x version.

Also make sure that you backup your data before you start.

Update your docker compose with new versions.

``` yaml
# For bar assistant server
image: barassistant/server:v4
# For salt rim
image: barassistant/salt-rim:v3
```

Docker image for API is now exposed on port 8080 insted of 3000, so you need to update your nginx config.

```
proxy_pass http://bar-assistant:8080/;
```

Then pull and restart the stack:

``` bash
$ docker compose pull
$ docker compose up -d
```