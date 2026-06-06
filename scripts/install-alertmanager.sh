#!/bin/bash

sudo useradd --no-create-home --shell /bin/false alertmanager || true

sudo mkdir -p /etc/alertmanager
sudo mkdir -p /var/lib/alertmanager

cd /tmp

wget https://github.com/prometheus/alertmanager/releases/download/v0.28.1/alertmanager-0.28.1.linux-amd64.tar.gz

tar -xvzf alertmanager-0.28.1.linux-amd64.tar.gz

sudo cp alertmanager-0.28.1.linux-amd64/alertmanager /usr/local/bin/
sudo cp alertmanager-0.28.1.linux-amd64/amtool /usr/local/bin/

sudo cp /home/ec2-user/Prometheus-Grafana/monitoring-server/alertmanager.yml /etc/alertmanager/
sudo cp /home/ec2-user/Prometheus-Grafana/monitoring-server/alertmanager.service /etc/systemd/system/
sudo cp /home/ec2-user/Prometheus-Grafana/monitoring-server/alert.rules.yml /etc/prometheus/

sudo systemctl daemon-reload
sudo systemctl enable alertmanager
sudo systemctl start alertmanager

sudo systemctl status alertmanager
