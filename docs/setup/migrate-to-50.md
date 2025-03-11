# Migration - v4.x to v5.0.0

## Prerequisites

- You are on latest v4.x version.
- You have [backups of your data](../faq.md#how-do-i-backup-my-data).

If you are using docker this process is simple. This version does not require any major changes to your docker-compose file.

``` yaml
# Bump your bar assistant image version
image: barassistant/server:v5
# Bump your salt-rim image version
image: barassistant/salt-rim:v4
```

Then pull and restart the stack:

``` bash
$ docker compose pull
$ docker compose up -d
```