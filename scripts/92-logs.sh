#!/bin/bash
# this script gives you the logs from the cron

if [[ $(command -v podman) ]]
then
    podman container logs --follow moodle-uai-docker_webcron_1 
else 
    docker container logs --since 1h --follow  moodle-uai-docker-webcron-1
fi
