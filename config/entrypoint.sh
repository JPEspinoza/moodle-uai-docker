#!/bin/bash
# this entrypoint setups php, the log folders
# installs and upgrades moodle, install uai block
# configures the php user and starts the server

echo "Configuring PHP..."

# copy the development or production php configuration 
cp "$PHP_INI_DIR/php.ini-${MODE}" "$PHP_INI_DIR/php.ini"

# add required variables to configuration
# max_input_vars is required by moodle
# variables_order is used so that php can read the container environment variables
echo '
max_input_vars = 5000
memory_limit = ${MEMORY_LIMIT}
post_max_size = ${MAX_UPLOAD_SIZE}
upload_max_filesize = ${MAX_UPLOAD_SIZE}
variables_order = EGPCS' >> $PHP_INI_DIR/php.ini

echo "Setting up moodle environment..."

# if moodle is not installed (no version.php)
# wipe the git folder and reinitialize
if [[ ! -f version.php ]]
then
    echo "Installing moodle"
    echo "This may take a while..."
    rm -rf .git
    git init 
    git remote add origin https://github.com/moodle/moodle.git
    git fetch
fi
echo "Upgrading moodle..."
git checkout ${VERSION}
git pull --ff-only

# install block, since its required by the config.php
# check if the folder where the plugin goes has the version.php file
# if the folder or the file don't exist, pull
# we then remove the .git folder, whose permissions prevent moodle from overwriting
# the plugin
if [[ ! -f blocks/uai/version.php ]]
then
    echo "Installing UAI block"
    git clone https://github.com/webcursosqa/uai.git blocks/uai
    rm -rf blocks/uai/.git
fi

# setup the moodle user
# if 0, we run as root
# otherwise, we run as phpuser
echo "Configuring PHP user..."
if [[ $UID -eq 0 ]]
then
    # if $UID is 0 we modify www.conf to run as root
    sed -i 's/www-data/root/' /usr/local/etc/php-fpm.d/www.conf
else
    # if $UID is not 0 we create a phpuser user and 
    # modify www.conf to run as phpuser
    sed -i 's/www-data/phpuser/' /usr/local/etc/php-fpm.d/www.conf
    groupadd -g $UID phpuser
    useradd phpuser -u $UID -g $UID -m -s /bin/bash
fi

echo "Changing owner of moodle and moodledata..."
chown $UID:$UID /moodle -R
chown $UID:$UID /moodledata -R

# create paperattendance log if not exist
# if it exists then it fails silently
# then we change the owner of the file to the uid
echo "Setting up log folder..."
mkdir /var/log/moodle
touch /var/log/moodle/paperattendance.log
chown $UID:$UID /var/log/moodle -R

# replace bash with php-fpm
echo "Starting server..."

# we start the server with exec to allow docker to track the entrypoint process
exec php-fpm --allow-to-run-as-root
