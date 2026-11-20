#!/bin/bash
# TP1, étape 2 : installation de PostgreSQL par script.
# À lancer deux fois de suite sur la même VM, puis observer.
# Usage : sudo bash install.sh
set -e

apt-get update
apt-get install -y postgresql
echo "127.0.0.1 db.local" >> /etc/hosts
sudo -u postgres createuser app
sudo -u postgres createdb -O app appdb
