FROM php:8.0-fpm

# copy the entrypoint and config
# the entrypoint is executed at /
# config is later copied again into the moodle volume
# config has tweakable variables
COPY ./config/entrypoint.sh /entrypoint.sh

WORKDIR /moodle

# add script for installing php extensions
# make entry script executable
# install os dependencies
# make extension installer executable
# install php required extensions
# copy php config
# add required variables to php config
# edit imagemagick policy to allow editing pdfs
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN true && \
    chmod +x /entrypoint.sh && \
    apt-get update && \
    apt-get install git ghostscript aspell-en aspell-es locales locales-all graphviz poppler-utils python3 openjdk-17-jre-headless libgs-dev -y && \
    rm -rf /var/lib/apt/lists/* && \
    chmod +x /usr/local/bin/install-php-extensions && \
    MAKEFLAGS="-j$(nproc)" install-php-extensions redis opcache mysqli zip gd intl soap ldap exif xmlrpc imagick && \
    sed -i '/<policy domain="coder" rights="none" pattern="PS" \/>/d' /etc/ImageMagick-6/policy.xml  && \
    sed -i '/<policy domain="coder" rights="none" pattern="PS2" \/>/d' /etc/ImageMagick-6/policy.xml && \
    sed -i '/<policy domain="coder" rights="none" pattern="PS3" \/>/d' /etc/ImageMagick-6/policy.xml && \
    sed -i '/<policy domain="coder" rights="none" pattern="EPS" \/>/d' /etc/ImageMagick-6/policy.xml && \
    sed -i '/<policy domain="coder" rights="none" pattern="PDF" \/>/d' /etc/ImageMagick-6/policy.xml && \
    sed -i '/<policy domain="coder" rights="none" pattern="XPS" \/>/d' /etc/ImageMagick-6/policy.xml

ENTRYPOINT ["/entrypoint.sh"]