# -*- mode: hcl -*-
images = {
    nginx = {
        name = "nginx"
        version = "1.19.3"
    }
    grafana = {
        name = "grafana/grafana"
        version = "7.2.1"
    }
    plex = {
        name = "linuxserver/plex"
        version = "1.20.3.3483-211702a9f-ls120"
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
        version = "v2.21.0"
    }
    synapse = {
        name = "matrixdotorg/synapse"
        version = "v1.20.1"
    }
    unifi = {
        name = "linuxserver/unifi-controller"
        version = "6.0.23-ls81"
    }
}
