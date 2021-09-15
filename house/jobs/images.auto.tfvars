# -*- mode: hcl -*-
images = {
    nginx = {
        name = "nginx"
        version = "1.21.3"
    }
    grafana = {
        name = "grafana/grafana"
        version = "8.1.3"
    }
    homeassistant = {
        name = "homeassistant/home-assistant"
        version = "2021.9.6"
    }
    plex = {
        name = "linuxserver/plex"
        version = "1.24.2.4973-2b1b51db9-ls74"
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
        version = "v2.30.0"
    }
    synapse = {
        name = "matrixdotorg/synapse"
        version = "v1.42.0"
    }
    unifi = {
        name = "linuxserver/unifi-controller"
        version = "6.2.26-ls114"
    }
}
