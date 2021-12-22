# -*- mode: hcl -*-
images = {
    nginx = {
        name = "nginx"
        version = "1.21.4"
    }
    grafana = {
        name = "grafana/grafana"
        version = "8.3.3"
    }
    homeassistant = {
        name = "homeassistant/home-assistant"
        version = "2021.12.4"
    }
    plex = {
        name = "linuxserver/plex"
        version = "1.25.2"
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
        version = "v1.49.2"
    }
    unifi = {
        name = "linuxserver/unifi-controller"
        version = "6.5.55"
    }
}
