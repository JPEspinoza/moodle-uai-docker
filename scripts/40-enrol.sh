#!/bin/bash
# this script runs the database enrol for enrolling users from sync

if [[ $(command -v podman) ]]
then
    podman container exec moodle-uai-docker_php_1 php /moodle/enrol/database/cli/sync.php
else 
    docker container exec moodle-uai-docker-php-1 php /moodle/enrol/database/cli/sync.php
fi
