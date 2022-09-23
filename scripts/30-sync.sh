#!/bin/bash
# this script runs the uai sync

if [[ $(command -v podman) ]]
then
    podman container exec moodle-uai-docker_php_1 php /moodle/local/sync/cli/syncomega.php
else 
    docker container exec moodle-uai-docker-php-1 php /moodle/local/sync/cli/syncomega.php
fi
