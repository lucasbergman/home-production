# -*- mode: hcl -*-
images = {
    nginx = {
        name = "nginx"
        version = "1.21.6"
    }
    grafana = {
        name = "grafana/grafana"
        version = "8.4.4"
    }
    homeassistant = {
        name = "homeassistant/home-assistant"
        version = "2022.3.5"
    }
    plex = {
        name = "linuxserver/plex"
        version = "1.25.7"
    }
    prom_alertmanager = {
        name = "prom/alertmanager"
        version = "v0.23.0"
    }
    prom_blackbox = {
        name = "prom/blackbox-exporter"
        version = "v0.20.0"
    }
    prom_prometheus = {
        name = "prom/prometheus"
        version = "v2.34.0"
    }
    synapse = {
        name = "matrixdotorg/synapse"
        version = "v1.54.0"
    }
    unifi = {
        name = "linuxserver/unifi-controller"
        version = "6.5.55"
    }
}
