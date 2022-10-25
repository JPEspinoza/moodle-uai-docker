#!/bin/bash
# this entrypoint clones moodle, switches to the branch MOODLE_400_STABLE and downloads the following plugins
# - paperattendance
# - emarking
# - sync
# - urluai
# - reservasalas
# - notasuai
# - uai (block)

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

# create paperattendance log if not exist
mkdir /var/log/moodle
touch /var/log/moodle/paperattendance.log

echo "Setting up moodle environment..."

if [[ ! -f version.php ]]
then
    echo "Installing moodle"
    echo "This may take a while..."
    git clone https://github.com/moodle/moodle.git .
fi
echo "Upgrading moodle..."
git checkout MOODLE_400_STABLE
git pull --ff-only

# install the plugins if not installed yet
# check if the folder where the plugin goes has the version.php file
# if the folder or the file don't exist, pull
if [[ ! -f blocks/uai/version.php ]]
then
    echo "Installing uai block"
    git clone https://github.com/webcursosqa/uai.git blocks/uai
fi

if [[ ! -f mod/emarking/version.php ]]
then
    echo "Installing emarking"
    git clone https://github.com/webcursosqa/emarking.git mod/emarking
fi

if [[ ! -f local/sync/version.php ]]
then
    echo "Installing sync"
    git clone https://github.com/webcursosqa/sync.git local/sync
fi

if [[ ! -f local/reservasalas/version.php ]]
then
    echo "Installing reservasalas"
    git clone https://github.com/webcursosqa/reservasalas.git local/reservasalas
fi

if [[ ! -f local/paperattendance/version.php ]]
then
    echo "Installing paperattendance"
    git clone https://github.com/webcursosqa/paperattendance.git local/paperattendance
fi

echo "Configuring user..."
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

# replace bash with php-fpm
echo "Starting server..."

# we start the server with exec to allow docker to track the entrypoint process
exec php-fpm --allow-to-run-as-root
