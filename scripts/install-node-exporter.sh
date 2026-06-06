#!/bin/bash

set -e

NODE_EXPORTER_VERSION="1.9.1"

echo "Downloading Node Exporter..."

cd /tmp

wget https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz

tar -xvf node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz

echo "Creating node_exporter user..."

id node_exporter &>/dev/null || useradd --no-create-home --shell /bin/false node_exporter

echo "Installing binary..."

sudo cp node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64/node_exporter /usr/local/bin/

sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter
sudo chmod +x /usr/local/bin/node_exporter

echo "Creating systemd service..."

cat <<EOF | sudo tee /etc/systemd/system/node_exporter.service > /dev/null
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

echo "Reloading systemd..."

sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl restart node_exporter

echo "Checking status..."

sudo systemctl status node_exporter --no-pager

echo "Node Exporter installation completed successfully.""
