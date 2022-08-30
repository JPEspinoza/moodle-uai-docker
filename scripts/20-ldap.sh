#!/bin/bash
# this script does ldap sync to bring the users from omega

if [[ $(command -v podman) ]]
then
    podman container exec moodle_php_1 php /moodle/auth/ldap/cli/sync_users.php
else 
    docker container exec docker-uai-moodle-php-1 php /moodle/auth/ldap/cli/sync_users.php
fi
