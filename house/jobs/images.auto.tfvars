# -*- mode: hcl -*-
images = {
    nginx = {
        name = "nginx"
        version = "1.21.6"
    }
    grafana = {
        name = "grafana/grafana"
        version = "8.3.4"
    }
    homeassistant = {
        name = "homeassistant/home-assistant"
        version = "2021.12.10"
    }
    plex = {
        name = "linuxserver/plex"
        version = "1.25.3"
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
        version = "v2.32.1"
    }
    synapse = {
        name = "matrixdotorg/synapse"
        version = "v1.51.0"
    }
    unifi = {
        name = "linuxserver/unifi-controller"
        version = "6.5.55"
    }
}
