#!/bin/bash

# Deploy
# 0. ./release.sh; copy build to server
# 1. cd /opt; tar -zxf ultimate-rehab.tar.gz
# 2. Create /opt/ultimate-rehab/private_config.yaml
# 3. /opt/ultimate-rehab/setup.sh
# 4. install webserver and TLS certs

set -euo pipefail

SOURCE=$( readlink "${BASH_SOURCE[0]}" || echo "${BASH_SOURCE[0]}" )
DIR=$( cd "$( dirname "$SOURCE" )" && pwd )
UR_MODE="${UR_MODE:-prod}"

if [ "$(id -u)" -ne 0 ];
then
    echo "error: script must run as root"
    exit 1;
elif [ "$(lsb_release -r | cut -f2)" != "16.04" ];
then
    echo "error: operating system must be Ubuntu 16.04"
    exit 1
elif [ "/opt/ultimate-rehab" != "$DIR" ];
then
    echo "error: ultimate rehab installation must be at '/opt/ultimate-rehab'"
    exit 1
elif [ ! -f "$DIR/private_config.yaml" ];
then
    echo "error: $DIR/private_config.yaml missing"
    exit 1
fi

# Bundler expects application directory as pwd
cd "$DIR"

apt-get update
adduser --home /home/app --disabled-login --gecos '' app
sudo chown -R app:app "$DIR"
sudo chmod -R 770 "$DIR"

# postgres
apt-get -y install postgresql libpq-dev
su postgres <<EOF
    createuser app
    createdb ultimaterehab
EOF
PG_HBA=$(su postgres -c "psql -t -P format=unaligned -c 'SHOW hba_file'")
echo "local ultimaterehab app peer" > "$PG_HBA"
if [ ! -f "$PG_HBA" ]; then
    echo "error: pg config not at $PG_HBA"
    exit 1
fi
service postgresql restart

# ruby
apt-get -y install ruby ruby-dev rubygems build-essential g++
gem install bundler
su app <<EOF
    bundle install --deployment
EOF

# Start application
su app <<EOF
    bundle exec ruby "$DIR/backend/migrations/migration0.rb"
EOF
"$DIR/restart.sh"

echo "Installation complete [$UR_MODE]: services running"
exit 0
