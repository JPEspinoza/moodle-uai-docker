# Podman Moodle

This Podman pod deploy UAI webcursos, automatically downloading the latest version of moodle and the relevant plugins.

This pod uses nginx, php-fpm 8.0, and mariadb. It's designed to be used both in a development and production environment and has been tuned for maximum performance, making use of Redis and the JIT opcache introduced in PHP 8.

## Plugins auto installed
- uai (block)
- emarking
- sync
- reservasalas
- paperattendance
- urluai
- notasuai

## Automatic Setup
This pod automatically installs Moodle and the UAI (public) plugins

## Scripts
In the `scripts` folder you can find some helper scripts

- `10-cron.sh`: runs the cron
- `20-ldap.sh`: syncs the users from ldap (after configuring ldap authentication)
- `30-sync.sh`: syncs the sync plugin (after creating a synchronization)
- `40-enrol.sh`: creates the courses synced by `sync` and enrols the users into the courses (after configuring database enrol)

For a successful setup, the required configuration must be filled into the settings and the scripts must be run in order. The cron can be run at any time you would like to check the output. Prefer allowing the cron to run normally and checking the logs through the moodle settings.

## File structure
- The `volumes` folder contains dynamic data that is filled on runtime.
    - The `mariadb` folder contains the database files. You are not supposed to modify these.
    - The `moodle` folder contains the Moodle install. It can be modified if so desired.
    - The `moodledata` folder contains the Moodle `dataroot` files. You are not supposed to modify these.
- The `config` folder contains a few configuration files that are setup through environment variables in docker-compose.yml. 

## Requirements
- `podman`
- `podman-compose` 1.0.4 

or
- `docker`

## Tested on
- Fedora 36
- CentOS 7: using docker!
    - https://docs.docker.com/engine/install/centos/

## How to use
1. modify `docker-compose.yml` to liking
2. modify `config/config.php` to liking, prefer using `docker-compose.yml` if possible.
3. run `podman-compose up` or `docker compose up`

## How to modify variables
1. modify the desired variable in `docker-compose.yml`
2. run `podman-compose down` to destroy the containers
3. run `podman-compose up` to rebuild the containers with the new variables

## Notice
On first run it will take a while as moodle is downloaded. The server will be ready once you see the `[php] clone complete` message.

## TODO
- private repo support (maybe a folder to leave your private key into?)
- Auto configuration
    - database enrol
    - ldap
    - sync
    - paperattendance
    - emarking