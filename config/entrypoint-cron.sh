#!/bin/bash

# this script runs php on 
# /moodle/admin/cli/cron.php

# update the php config
# the php config is separate for each container
# this is necesary to allow variables like memory limit to exist
echo "Updating php config"
cp "$PHP_INI_DIR/php.ini-${MODE}" "$PHP_INI_DIR/php.ini"

# add required variables to configuration
echo '
max_input_vars = 5000
memory_limit = ${MEMORY_LIMIT}
post_max_size = ${MAX_UPLOAD_SIZE}
upload_max_filesize = ${MAX_UPLOAD_SIZE}
opcache.enable=1
opcache.enable_cli=1
opcache.jit_buffer_size=128M
opcache.jit=1255
variables_order = EGPCS' >> $PHP_INI_DIR/php.ini

# the moodle config is updated by the php container
# so no need to worry about that one

# do while
# sleep 60 seconds
# check if version.php exists
# if it doesn't exist we wait 60 seconds more
# if it exists we exit the loop
while 
    sleep 60
    [[ ! -f version.php ]]
do true
done

# every 60 seconds run the cron
# for the cron the user doesn't matter, we just use www-data
while true
do
    echo "Running cron..."
    php admin/cli/cron.php
    sleep 60
done