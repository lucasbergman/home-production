# -*- mode: hcl -*-
images = {
    nginx = {
        name = "nginx"
        version = "1.21.0"
    }
    grafana = {
        name = "grafana/grafana"
        version = "8.0.3"
    }
    homeassistant = {
        name = "homeassistant/home-assistant"
        version = "2021.6.6"
    }
    plex = {
        name = "linuxserver/plex"
        version = "1.23.3.4707-ebb5fe9f3-ls58"
    }
    prom_alertmanager = {
        name = "prom/alertmanager"
        version = "v0.22.2"
    }
    prom_blackbox = {
        name = "prom/blackbox-exporter"
        version = "v0.19.0"
    }
    prom_prometheus = {
        name = "prom/prometheus"
        version = "v2.28.0"
    }
    synapse = {
        name = "matrixdotorg/synapse"
        version = "v1.36.0"
    }
    unifi = {
        name = "linuxserver/unifi-controller"
        version = "6.2.26-ls114"
    }
}
