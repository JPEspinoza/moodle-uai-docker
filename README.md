# Podman Moodle

This Podman pod deploy UAI webcursos, automatically downloading the latest version of moodle and the relevant plugins

This pod uses Nginx, php-fpm 8.0, Redis and mariadb. It's designed to be used both in a development and production environment.

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

The user is supposed to create the admin user at first login and create the context `Pregrado` at id `406`

## File structure
- The `volumes` folder contains dynamic data that is filled on runtime.
    - The `mariadb` folder contains the database files. You are not supposed to modify these.
    - The `moodle` folder contains the Moodle install. It can be modified if so desired.
    - The `moodledata` folder contains the Moodle `dataroot` files. You are not supposed to modify these.
- The `config` folder contains a few configuration files that are setup through environment variables in podman-compose.yml. You are not supposed to modify these, and doing so requires rebuilding the php image.
- The `.env` file contains the required variables for the pod, such as the server URL. You are to fill these in before usage.

## Requirements
- `podman`
- `podman-compose` 1.0.4

## Tested on
- Fedora 36

## How to use
1. modify the variables in `.env`
2. run `podman-compose up`

## Notice
On first run it will take a while as moodle is downloaded. The server will be ready once you see the `[php] clone complete` message.

## TODO
- private repo support (maybe a folder to leave your private key into?)
- RemUI support (a folder to leave the relevant files)
- Auto configuration
    - database enrol
    - ldap
    - sync
    - paperattendance
    - emarking