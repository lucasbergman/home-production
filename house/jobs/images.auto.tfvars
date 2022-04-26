# -*- mode: hcl -*-
images = {
    nginx = {
        name = "nginx"
        version = "1.21.6"
    }
    grafana = {
        name = "grafana/grafana"
        version = "8.5.0"
    }
    homeassistant = {
        name = "homeassistant/home-assistant"
        version = "2022.4.7"
    }
    plex = {
        name = "linuxserver/plex"
        version = "1.26.0"
    }
    prom_alertmanager = {
        name = "prom/alertmanager"
        version = "v0.24.0"
    }
    prom_blackbox = {
        name = "prom/blackbox-exporter"
        version = "v0.20.0"
    }
    prom_prometheus = {
        name = "prom/prometheus"
        version = "v2.35.0"
    }
    synapse = {
        name = "matrixdotorg/synapse"
        version = "v1.57.1"
    }
    unifi = {
        name = "linuxserver/unifi-controller"
        version = "7.0.25"
    }
}
