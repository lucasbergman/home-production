# -*- mode: hcl -*-
images = {
    nginx = {
        name = "nginx"
        version = "1.23.1"
    }
    apcupsd_exporter = {
        name = "gcr.io/bergmans-services/apcupsd_exporter"
        version = "20220621T1855-42e619b"
    }
    grafana = {
        name = "grafana/grafana"
        version = "9.1.1"
    }
    homeassistant = {
        name = "homeassistant/home-assistant"
        version = "2022.8.6"
    }
    plex = {
        name = "linuxserver/plex"
        version = "1.28.1"
    }
    prom_alertmanager = {
        name = "prom/alertmanager"
        version = "v0.24.0"
    }
    prom_blackbox = {
        name = "prom/blackbox-exporter"
        version = "v0.22.0"
    }
    prom_prometheus = {
        name = "prom/prometheus"
        version = "v2.38.0"
    }
    synapse = {
        name = "matrixdotorg/synapse"
        version = "v1.65.0"
    }
    unifi = {
        name = "linuxserver/unifi-controller"
        version = "7.2.92"
    }
}
