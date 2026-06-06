#!/bin/bash

sudo useradd --no-create-home --shell /bin/false prometheus || true

sudo mkdir -p /etc/prometheus
sudo mkdir -p /var/lib/prometheus

cd /tmp

wget https://github.com/prometheus/prometheus/releases/download/v3.4.2/prometheus-3.4.2.linux-amd64.tar.gz

tar -xvzf prometheus-3.4.2.linux-amd64.tar.gz

sudo cp prometheus-3.4.2.linux-amd64/prometheus /usr/local/bin/
sudo cp prometheus-3.4.2.linux-amd64/promtool /usr/local/bin/

sudo cp /home/ec2-user/Prometheus-Grafana/monitoring-server/prometheus.yml /etc/prometheus/

sudo cp /home/ec2-user/Prometheus-Grafana/monitoring-server/prometheus.service /etc/systemd/system/

sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus

sudo systemctl status prometheus
