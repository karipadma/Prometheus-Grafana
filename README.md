# Nginx + EC2 Monitoring Stack

## Architecture
EC2-1 → Nginx App Server  
EC2-2 → Prometheus + Grafana + Alertmanager  

---

## Setup Order

### 1. App Server
- Install Nginx
- Install Node Exporter

wget https://github.com/prometheus/node_exporter/releases/latest/download/node_exporter-*.tar.gz

tar -xzf node_exporter-*.tar.gz
sudo cp node_exporter-*/node_exporter /usr/local/bin/

#Create service 

/etc/systemd/system/node_exporter.service
add below code

[Unit]
Description=Node Exporter
After=network.target

[Service]
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target

#Start 
sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter

### 2. Monitoring Server
- Install Prometheus
- Install Grafana
- Install Alertmanager


#On Monitoring EC2:

sudo systemctl restart prometheus
sudo systemctl restart grafana-server
sudo systemctl restart alertmanager
---

## Ports

- Nginx: 80
- Node Exporter: 9100
- Prometheus: 9090
- Grafana: 3000
- Alertmanager: 9093

---

## Dashboard

Grafana → Import ID: 1860


🟢 PART 1 — BEFORE RUNNING (VERY IMPORTANT)

🔐 1. Open Security Group Ports
For EC2-1 (App Server)
Port	Purpose
22	SSH
80	Nginx
9100	Node exporter

For EC2-2 (Monitoring Server)
Port	Purpose
22	SSH
3000	Grafana
9090	Prometheus
9093	Alertmanager

🟡 PART 2 — CONNECT TO SERVERS
ssh -i key.pem ec2-user@EC2-1-IP   # App server
ssh -i key.pem ec2-user@EC2-2-IP   # Monitoring server

🟢 PART 3 — RUN APP SERVER (EC2-1)
📌 Step 1: Run Nginx install script
chmod +x install-nginx.sh
sudo ./install-nginx.sh
📌 Step 2: Check Nginx is running
sudo systemctl status nginx
🌐 Step 3: Access Nginx App

Open browser:

http://EC2-1-PUBLIC-IP

You should see:

NGINX APP SERVER IS RUNNING
📌 Step 4: Start Node Exporter (IMPORTANT)
sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter
🔍 Verify Node Exporter
curl http://localhost:9100/metrics

🔵 PART 4 — RUN MONITORING SERVER (EC2-2)
📌 Step 1: Make scripts executable
cd scripts
chmod +x *.sh
📌 Step 2: Install Prometheus
sudo ./install-prometheus.sh

Then copy config:

sudo cp ../monitoring-server/prometheus.yml /etc/prometheus/
sudo cp ../monitoring-server/alert.rules.yml /etc/prometheus/
📌 Step 3: Start Prometheus
sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus
🔍 Check Prometheus is working
curl http://localhost:9090/-/healthy
🌐 Access Prometheus UI
http://EC2-2-PUBLIC-IP:9090

📌 Step 4: Install Grafana
sudo ./install-grafana.sh

Start:

sudo systemctl enable grafana-server
sudo systemctl start grafana-server
🌐 Access Grafana Dashboard
http://EC2-2-PUBLIC-IP:3000
Login:
Username: admin
Password: admin

📌 Step 5: Add Prometheus in Grafana

Inside Grafana UI:

⚙️ Settings → Data Sources → Add Data Source

Select:

Prometheus

URL:

http://localhost:9090

Click:

Save & Test
📊 Step 6: Import Dashboard

Go to:

Dashboards → Import

Enter ID:

1860

Select Prometheus → Import

📌 Step 7: Install Alertmanager
sudo ./install-alertmanager.sh

Copy config:

sudo cp ../monitoring-server/alertmanager.yml /etc/alertmanager/

Start:

sudo systemctl enable alertmanager
sudo systemctl start alertmanager
🌐 Access Alertmanager
http://EC2-2-PUBLIC-IP:9093

🔴 PART 5 — CONNECT PROMETHEUS TO APP SERVER

Edit Prometheus config:

sudo vi /etc/prometheus/prometheus.yml

Update this part:

scrape_configs:
  - job_name: "nginx-app"
    static_configs:
      - targets: ["EC2-1-IP:9100"]

Restart Prometheus:

sudo systemctl restart prometheus
🟣 PART 6 — VERIFY EVERYTHING WORKS
1. Prometheus Targets
http://EC2-2-IP:9090/targets

You should see:

UP (node exporter)
UP (prometheus)
2. Grafana Dashboard
http://EC2-2-IP:3000

Check:

CPU usage
Memory usage
Disk usage
3. App Server
http://EC2-1-IP
🔥 FINAL FLOW (WHAT SHOULD WORK)
EC2-1 (Nginx + Node Exporter)
          ↓
EC2-2 (Prometheus scrapes metrics)
          ↓
Grafana dashboards visualize
          ↓
Alertmanager sends alerts
💡 MOST IMPORTANT DEBUG COMMANDS
Check services:
sudo systemctl status prometheus
sudo systemctl status grafana-server
sudo systemctl status node_exporter
sudo systemctl status alertmanager
Check ports:
ss -tulpn
Check logs:
journalctl -u prometheus -f
journalctl -u grafana-server -f