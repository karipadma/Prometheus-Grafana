#!/bin/bash

cat <<EOF > /etc/yum.repos.d/grafana.repo
[grafana]
name=Grafana
baseurl=https://rpm.grafana.com
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://rpm.grafana.com/gpg.key
EOF

dnf install grafana -y
systemctl enable grafana-server
systemctl start grafana-server