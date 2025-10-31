#!/bin/bash
set -euo pipefail

#VARS
LINK=$1
ARCHIVE="/tmp/prometheus.tar.gz"
DIR="/tmp/prometheus"


wget "$LINK" -O "$ARCHIVE"

# Создание директории и распаковка
mkdir -p "$DIR"
tar -xzf "$ARCHIVE" -C "$DIR"


cd "$DIR"/node*
rm NOTICE LICENSE

sudo mv node* /usr/bin/

# Создание пользователя, если не существует
if ! sudo id -u node_exporter &> /dev/null; then
  sudo useraddd -rs /bin/false node_exporter
fi


sudo chown node_exporter:node_exporter /usr/bin/node_exporter

# Создание службы
sudo tee /etc/systemd/system/nodeExporter.service > /dev/null <<'EOF'
[Unit]
Description=Node exporter for Prometheus Server
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
Restart=on-failure
ExecStart=/usr/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF


#Запуск службы
sudo systemctl daemon-reload
sudo systemctl enable nodeExporter.service
sudo systemctl start nodeExporter.service
sudo systemctl status nodeExporter.service

rm -rf "$ARCHIVE" "$DIR"
