# -*- mode: hcl -*-
images = {
    nginx = {
        name = "nginx"
        version = "1.21.3"
    }
    grafana = {
        name = "grafana/grafana"
        version = "8.2.1"
    }
    homeassistant = {
        name = "homeassistant/home-assistant"
        version = "2021.10.4"
    }
    plex = {
        name = "linuxserver/plex"
        version = "1.24.4"
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
        version = "v2.30.3"
    }
    synapse = {
        name = "matrixdotorg/synapse"
        version = "v1.44.0"
    }
    unifi = {
        name = "linuxserver/unifi-controller"
        version = "6.4.54"
    }
}
