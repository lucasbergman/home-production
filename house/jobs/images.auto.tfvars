# -*- mode: hcl -*-
images = {
    nginx = {
        name = "nginx"
        version = "1.21.4"
    }
    grafana = {
        name = "grafana/grafana"
        version = "8.2.5"
    }
    homeassistant = {
        name = "homeassistant/home-assistant"
        version = "2021.11.5"
    }
    plex = {
        name = "linuxserver/plex"
        version = "1.24.5"
    }
    prom_alertmanager = {
        name = "prom/alertmanager"
        version = "v0.23.0"
    }
    prom_blackbox = {
        name = "prom/blackbox-exporter"
        version = "v0.19.0"
    }
    prom_prometheus = {
        name = "prom/prometheus"
        version = "v2.31.1"
    }
    synapse = {
        name = "matrixdotorg/synapse"
        version = "v1.47.1"
    }
    unifi = {
        name = "linuxserver/unifi-controller"
        version = "6.5.53"
    }
}
