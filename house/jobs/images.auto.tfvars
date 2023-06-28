# -*- mode: hcl -*-
images = {
  nginx = {
    name    = "nginx"
    version = "1.25.1"
  }
  apcupsd_exporter = {
    name    = "gcr.io/bergmans-services/apcupsd_exporter"
    version = "20220621T1855-42e619b"
  }
  grafana = {
    name    = "grafana/grafana"
    version = "9.4.7"
  }
  homeassistant = {
    name    = "homeassistant/home-assistant"
    version = "2023.6.3"
  }
  plex = {
    name    = "linuxserver/plex"
    version = "1.32.4"
  }
  prom_alertmanager = {
    name    = "prom/alertmanager"
    version = "v0.25.0"
  }
  prom_prometheus = {
    name    = "prom/prometheus"
    version = "v2.45.0"
  }
  unifi = {
    name    = "linuxserver/unifi-controller"
    version = "7.4.156"
  }
}
