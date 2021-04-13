# -*- mode: hcl -*-
images = {
    nginx = {
        name = "nginx"
        version = "1.19.10"
    }
    grafana = {
        name = "grafana/grafana"
        version = "7.5.3"
    }
    plex = {
        name = "linuxserver/plex"
        version = "1.21.2.3943-a91458577-ls21"
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
        version = "v1.31.0"
    }
    unifi = {
        name = "linuxserver/unifi-controller"
        version = "6.1.71-ls102"
    }
}
