#!/bin/bash
# this script runs the cron

if [[ $(command -v podman) ]]
then
    podman container exec moodle_php_1 php /moodle/admin/cli/cron.php
else 
    docker container exec docker-uai-moodle-php-1 php /moodle/admin/cli/cron.php
fi
