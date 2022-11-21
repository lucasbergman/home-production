# -*- mode: hcl -*-
images = {
  nginx = {
    name    = "nginx"
    version = "1.23.2"
  }
  apcupsd_exporter = {
    name    = "gcr.io/bergmans-services/apcupsd_exporter"
    version = "20220621T1855-42e619b"
  }
  grafana = {
    name    = "grafana/grafana"
    version = "9.2.4"
  }
  homeassistant = {
    name    = "homeassistant/home-assistant"
    version = "2022.11.2"
  }
  plex = {
    name    = "linuxserver/plex"
    version = "1.29.2"
  }
  prom_alertmanager = {
    name    = "prom/alertmanager"
    version = "v0.24.0"
  }
  prom_blackbox = {
    name    = "prom/blackbox-exporter"
    version = "v0.22.0"
  }
  prom_prometheus = {
    name    = "prom/prometheus"
    version = "v2.40.1"
  }
  unifi = {
    name    = "linuxserver/unifi-controller"
    version = "7.2.95"
  }
}
