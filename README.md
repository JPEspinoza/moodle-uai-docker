# Podman Moodle

This pod deploys Moodle using nginx, php-fpm 7.4, and mariadb. It's designed to be used both in a development and production environment.

It automatically installs uai block

## Requirements
- `podman`
- `podman-compose` 1.0.4 

or
- `docker`

## How to use
1. modify `.env` to liking
2. run `podman-compose up` or `docker compose up`

## Scripts
In the `scripts` folder you can find some helper scripts

- `10-cron.sh`: runs the cron
- `20-ldap.sh`: syncs the users from ldap (after configuring ldap authentication)
- `30-sync.sh`: syncs the sync plugin (after creating a synchronization)
- `40-enrol.sh`: creates the courses synced by `sync` and enrols the users into the courses (after configuring database enrol)
- `91-shell.sh`: opens a bash shell inside the php container
- `92-logs.sh`: shows and follows the last hour logs

For a successful setup, the required configuration must be filled into the settings and the scripts must be run in order. The cron can be run at any time you would like to check the output. Prefer allowing the cron to run normally and checking the logs through the moodle settings.

## File structure
- The `volumes` folder contains dynamic data that is filled on runtime.
    - The `moodle` folder contains the Moodle install.
    - The `mariadb` folder contains the database files. You are not supposed to modify these.
    - The `moodledata` folder contains the Moodle `dataroot` files. You are not supposed to modify these.
    - The `log` folder contains the `/var/log` folder, so that moodle logs can be persistant and easily read.
- The `config` folder contains a few configuration files that are setup through environment variables in docker-compose.yml. 

## Notice
On first run it will take a while as moodle is downloaded. The server will be ready once you see the `[php] clone complete` message.