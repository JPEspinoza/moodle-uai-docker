#!/bin/bash
# this script gives you a shell into the php container

if [[ $(command -v podman) ]]
then
    podman container exec moodle_php_1 bash
else 
    docker container exec docker-uai-moodle-php-1 bash
fi