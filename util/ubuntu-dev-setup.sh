#!/bin/bash
set -e

sudo apt update
sudo apt install -y postgresql postgresql-contrib

sudo apt install -y git python3 python3-pip

git clone https://github.com/uw-advanced-robotics/imagetagger.git
cd imagetagger

cp imagetagger/imagetagger/settings.py.example imagetagger/imagetagger/settings.py

pip3 install -r requirements.txt

source ~/.bashrc

# pg_createcluster 12 main
sudo mkdir /var/lib/postgres
sudo chmod 775 /var/lib/postgres
sudo chown postgres /var/lib/postgres

sudo -iu postgres /usr/lib/postgresql/10/bin/initdb --locale en_US.UTF-8 -D '/var/lib/postgres/data'
sudo systemctl start postgresql.service

sudo -iu postgres psql -c "CREATE USER imagetagger PASSWORD 'imagetagger';"
sudo -iu postgres psql -c "CREATE DATABASE imagetagger WITH OWNER imagetagger ENCODING UTF8;"

cd imagetagger
python3 ./manage.py migrate

python3 ./manage.py createsuperuser