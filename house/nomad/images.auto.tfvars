# -*- mode: hcl -*-
images = {
    grafana = {
        name = "grafana/grafana"
        version = "7.1.5"
    }
    plex = {
        name = "plexinc/pms-docker"
        version = "1.20.1.3252-a78fef9a9"
    }
    prom_alertmanager = {
        name = "prom/alertmanager"
        version = "v0.21.0"
    }
    prom_blackbox = {
        name = "prom/blackbox-exporter"
        version = "v0.17.0"
    }
    prom_prometheus = {
        name = "prom/prometheus"
        version = "v2.20.1"
    }
    synapse = {
        name = "matrixdotorg/synapse"
        version = "v1.19.3"
    }
    unifi = {
        name = "linuxserver/unifi-controller"
        version = "5.14.23-ls74"
    }
}
