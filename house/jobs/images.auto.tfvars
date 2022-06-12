# -*- mode: hcl -*-
images = {
    nginx = {
        name = "nginx"
        version = "1.21.6"
    }
    grafana = {
        name = "grafana/grafana"
        version = "8.5.5"
    }
    homeassistant = {
        name = "homeassistant/home-assistant"
        version = "2022.6.5"
    }
    plex = {
        name = "linuxserver/plex"
        version = "1.26.2"
    }
    prom_alertmanager = {
        name = "prom/alertmanager"
        version = "v0.24.0"
    }
    prom_blackbox = {
        name = "prom/blackbox-exporter"
        version = "v0.21.0"
    }
    prom_prometheus = {
        name = "prom/prometheus"
        version = "v2.36.1"
    }
    synapse = {
        name = "matrixdotorg/synapse"
        version = "v1.60.0"
    }
    unifi = {
        name = "linuxserver/unifi-controller"
        version = "7.1.66"
    }
}
