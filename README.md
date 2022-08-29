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
This pod automatically installs Moodle and fills the configuration for the installed plugins

The user is supposed to create the admin user at first login and create the category `Pregrado` at id `406`

## File structure
- The `volumes` folder contains dynamic data that is filled on runtime.
    - The `mariadb` folder contains the database files. You are not supposed to modify these.
    - The `moodle` folder contains the Moodle install. It can be modified if so desired.
    - The `moodledata` folder contains the Moodle `dataroot` files. You are not supposed to modify these.
- The `config` folder contains a few configuration files that are setup through environment variables in docker-compose.yml. You are not supposed to modify these, and doing so requires rebuilding the php image.
- The `plugins` folder contains a skeleton of moodle's folder structure. You may put plugins there to be automatically installed

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
2. run `podman-compose up`

## Notice
On first run it will take a while as moodle is downloaded. The server will be ready once you see the `[php] clone complete` message.

## Notice
When running on docker php will run as root and you won't be able to modify moodle files without root access. If you wish to use this image for development prefer podman, under which php will run as your user.

## TODO
- private repo support (maybe a folder to leave your private key into?)
- RemUI support (a folder to leave the relevant files)
- Auto configuration
    - database enrol
    - ldap
    - sync
    - paperattendance
    - emarking