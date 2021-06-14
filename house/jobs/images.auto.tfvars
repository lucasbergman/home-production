# -*- mode: hcl -*-
images = {
    nginx = {
        name = "nginx"
        version = "1.20.0"
    }
    grafana = {
        name = "grafana/grafana"
        version = "7.5.5"
    }
    homeassistant = {
        name = "homeassistant/home-assistant"
        version = "2021.6.4"
    }
    plex = {
        name = "linuxserver/plex"
        version = "1.22.3.4392-d7c624def-ls45"
    }
    prom_alertmanager = {
        name = "prom/alertmanager"
        version = "v0.21.0"
    }
    prom_blackbox = {
        name = "prom/blackbox-exporter"
        version = "v0.18.0"
    }
    prom_prometheus = {
        name = "prom/prometheus"
        version = "v2.26.0"
    }
    synapse = {
        name = "matrixdotorg/synapse"
        version = "v1.33.1"
    }
    unifi = {
        name = "linuxserver/unifi-controller"
        version = "6.1.71-ls102"
    }
}
