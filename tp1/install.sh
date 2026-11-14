#!/bin/bash
# TP1, étape 2 : installation par script.
# À lancer deux fois de suite sur la même VM, puis observer.
# Usage : sudo bash install.sh
set -e

apt-get update
apt-get install -y nginx postgresql
systemctl enable --now nginx postgresql
echo "<h1>Groupe 1</h1>" > /var/www/html/index.html
echo "127.0.0.1 db.local" >> /etc/hosts
sudo -u postgres createuser app
