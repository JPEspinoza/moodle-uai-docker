#!/bin/bash
# this script gives you the logs from the cron

if [[ $(command -v podman) ]]
then
    podman container logs --follow --since 1h moodle-uai-docker_php_1 
else 
    docker container logs --follow --since 1h moodle-uai-docker-php-1 
fi
