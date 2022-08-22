#!/bin/sh
# this entrypoint clones moodle, switches to the branch MOODLE_400_STABLE and downloads the following plugins
# - paperattendance
# - emarking
# - sync
# - urluai
# - reservasalas
# - notasuai
# - uai (block)

# install or upgrade
echo "Upgrading moodle..."
echo "This may take a while..."
echo "Don't worry if the cloning fails, this means that moodle is already installed"
git clone https://github.com/moodle/moodle.git .
git checkout MOODLE_400_STABLE
git pull

echo "Upgrading UAI block"
git clone https://github.com/webcursosqa/uai.git blocks/uai
git --git-dir blocks/uai/.git pull

echo "Upgrading emarking..."
git clone https://github.com/webcursosqa/emarking.git mod/emarking
git --git-dir mod/emarking/.git checkout moodle39v2
git --git-dir mod/emarking/.git pull

echo "Upgrading Sync"
git clone https://github.com/webcursosqa/sync.git local/sync
git --git-dir local/sync/.git checkout moodle39
git --git-dir local/sync/.git pull

echo "Upgrading reservasalas"
git clone https://github.com/webcursosqa/reservasalas.git local/reservasalas
git --git-dir local/reservasalas/.git checkout moodle39
git --git-dir local/reservasalas/.git pull

echo "Upgrading paperattendance"
git clone https://github.com/webcursosqa/paperattendance.git local/paperattendance
git --git-dir local/paperattendance/.git checkout moodle39
git --git-dir local/paperattendance/.git pull

echo "Updating moodle config"
rm config.php
cp /config.php config.php

echo "Starting server..."

# run command that will keep the server alive from now on
exec php-fpm --allow-to-run-as-root