#!/bin/bash

useradd --no-create-home prometheus
mkdir -p /etc/prometheus /var/lib/prometheus

cd /tmp
wget https://github.com/prometheus/prometheus/releases/latest/download/prometheus-*.tar.gz

tar -xzf prometheus-*.tar.gz
cp prometheus-*/prometheus /usr/local/bin/

systemctl daemon-reload
systemctl enable prometheus
systemctl start prometheus