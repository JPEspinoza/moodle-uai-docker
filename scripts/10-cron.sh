#!/bin/bash
# this script runs the cron

if [[ $(command -v podman) ]]
then
    podman container exec moodle-uai-docker_php_1 php /moodle/admin/cli/cron.php
else 
    docker container exec moodle-uai-docker-php-1 php /moodle/admin/cli/cron.php
fi
