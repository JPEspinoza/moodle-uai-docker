FROM php:8.0-fpm

# copy the entrypoint and config
# the entrypoint is executed at /
# config is later copied again into the moodle volume
# config has tweakable variables
COPY ./config/entrypoint.sh /entrypoint.sh
COPY ./config/config.php /config.php
WORKDIR /moodle

# add script for installing php extensions
# install os dependencies
# make extension installer executable
# install extensions
# force php to run as root (within the container)
# make entry script executable
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN apt-get update -y && \
    apt-get install git ghostscript aspell-en aspell-es graphviz poppler-utils python3 -y && \
    chmod +x /usr/local/bin/install-php-extensions && \ 
    MAKEFLAGS="-j$(nproc)" install-php-extensions redis igbinary zstd opcache mysqli zip gd intl soap ldap exif xmlrpc && \
    sed -i 's/www-data/root/' /usr/local/etc/php-fpm.d/www.conf && \
    chmod +x /entrypoint.sh

# the entry script does the following:
# upgrades moodle or installs if not installed
# upgrades plugins or installs if not installed
# replaces the config.php with the new one
ENTRYPOINT [ "bash", "/entrypoint.sh" ]

# php-fpm runs on port 9000
EXPOSE 9000