#!/bin/bash

useradd --no-create-home alertmanager
mkdir -p /etc/alertmanager /var/lib/alertmanager

cd /tmp
wget https://github.com/prometheus/alertmanager/releases/latest/download/alertmanager-*.tar.gz

tar -xzf alertmanager-*.tar.gz
cp alertmanager-*/alertmanager /usr/local/bin/

systemctl daemon-reload
systemctl enable alertmanager
systemctl start alertmanager