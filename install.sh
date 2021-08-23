#!/bin/bash

apt update -y && apt upgrade -y

PROMETHEUS_VERSION=2.29.1
NODE_EXPORTER_VERSION=1.2.2

# Initial setup

useradd --no-create-home --shell /bin/false prometheus
useradd --no-create-home --shell /bin/false node_exporter

mkdir /etc/prometheus && mkdir /var/lib/prometheus && mkdir /var/log/prometheus

chown -R prometheus:prometheus /etc/prometheus
chown -R prometheus:prometheus /var/lib/prometheus
chown -R prometheus:prometheus /var/log/prometheus

# Download prometheus server and node_exporter

wget https://github.com/prometheus/prometheus/releases/download/v$PROMETHEUS_VERSION/prometheus-$PROMETHEUS_VERSION.linux-amd64.tar.gz
wget https://github.com/prometheus/node_exporter/releases/download/v$NODE_EXPORTER_VERSION/node_exporter-$NODE_EXPORTER_VERSION.linux-amd64.tar.gz

# Extract Prometheus
tar xvf prometheus-$PROMETHEUS_VERSION.linux-amd64.tar.gz
cp prometheus-$PROMETHEUS_VERSION.linux-amd64/prometheus /usr/local/bin/
cp prometheus-$PROMETHEUS_VERSION.linux-amd64/promtool /usr/local/bin/
cp ./prometheus.yml /etc/prometheus/prometheus.yml

# Extract Node_Exporter
tar xvf node_exporter-$NODE_EXPORTER_VERSION.linux-amd64.tar.gz
cp node_exporter-$NODE_EXPORTER_VERSION.linux-amd64/node_exporter /usr/local/bin
chown node_exporter:node_exporter /usr/local/bin/node_exporter

# SystemD Services
cp ./node_exporter.service /etc/systemd/system/node_exporter.service
cp ./prometheus.service /etc/systemd/system/prometheus.service

systemctl daemon-reload

systemctl enable --now prometheus
systemctl enable --now node_exporter
