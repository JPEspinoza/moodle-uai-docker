#!/bin/bash
# this script runs the uai sync

if [[ command -v podman ]]
then
    podman container exec moodle_php_1 php /moodle/local/sync/cli/syncomega.php
else 
    docker container exec docker-uai-moodle-php-1 php /moodle/local/sync/cli/syncomega.php
fi
