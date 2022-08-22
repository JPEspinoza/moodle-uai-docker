FROM php:8.0-fpm-alpine

# copy the entrypoint and config
# the entrypoint is executed at /
# config is later copied again into the moodle volume
# config has tweakable variables
COPY ./config/entrypoint.sh /entrypoint.sh
COPY ./config/config.php /config.php
WORKDIR /moodle


# import MODE variable
ARG MODE

# add script for installing php extensions
# install git
# make extension installer executable
# install extensions
# move php configuration
# change setting required for moodle
# force php to run as root (within the container)
# make entry script executable
# run entry script
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN apk add git && \
    chmod +x /usr/local/bin/install-php-extensions && \ 
    MAKEFLAGS="-j$(nproc)" install-php-extensions redis igbinary zstd opcache mysqli zip gd intl soap ldap exif xmlrpc && \
    mv "$PHP_INI_DIR/php.ini-${MODE}" "$PHP_INI_DIR/php.ini" && \
    echo "max_input_vars = 5000" > /usr/local/etc/php/php.ini && \
    sed -i 's/www-data/root/' /usr/local/etc/php-fpm.d/www.conf && \
    chmod +x /entrypoint.sh

# the entry script does the following:
# upgrades moodle or installs if not installed
# upgrades plugins or installs if not installed
# replaces the config.php with the new one
ENTRYPOINT [ "/entrypoint.sh" ]

# php-fpm runs on port 9000
EXPOSE 9000