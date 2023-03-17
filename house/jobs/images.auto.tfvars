# -*- mode: hcl -*-
images = {
  nginx = {
    name    = "nginx"
    version = "1.23.3"
  }
  apcupsd_exporter = {
    name    = "gcr.io/bergmans-services/apcupsd_exporter"
    version = "20220621T1855-42e619b"
  }
  grafana = {
    name    = "grafana/grafana"
    version = "9.4.3"
  }
  homeassistant = {
    name    = "homeassistant/home-assistant"
    version = "2023.3.5"
  }
  plex = {
    name    = "linuxserver/plex"
    version = "1.31.2"
  }
  prom_alertmanager = {
    name    = "prom/alertmanager"
    version = "v0.25.0"
  }
  prom_prometheus = {
    name    = "prom/prometheus"
    version = "v2.42.0"
  }
  unifi = {
    name    = "linuxserver/unifi-controller"
    version = "7.3.83"
  }
}
