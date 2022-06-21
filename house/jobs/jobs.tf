resource "nomad_job" "nginx" {
    jobspec = templatefile("nomad/nginx.nomad", {
        image = var.images.nginx
        config_default = file("conf/nginx/default.conf")
        config_grafana = file("conf/nginx/grafana.conf")
        config_hass = file("conf/nginx/hass.conf")
        config_mon = file("conf/nginx/mon.conf")
        config_plex = file("conf/nginx/plex.conf")
        config_synapse = file("conf/nginx/synapse.conf")
    })
}

resource "nomad_job" "apcupsd_exporter" {
    jobspec = templatefile("nomad/apcupsd_exporter.nomad", {
        image = var.images.apcupsd_exporter
    })
}

resource "nomad_job" "grafana" {
    jobspec = templatefile("nomad/grafana.nomad", {
        image = var.images.grafana
        config_grafana = file("conf/grafana.ini")
    })
}

resource "nomad_job" "homeassistant" {
    jobspec = templatefile("nomad/homeassistant.nomad", {
        image = var.images.homeassistant
        config_main = file("conf/homeassistant/configuration.yaml")
        config_automation = file("conf/homeassistant/automations.yaml")
    })
}

resource "nomad_job" "plex" {
    jobspec = templatefile("nomad/plex.nomad", {
        image = var.images.plex
        uids = var.house_uids.plex
    })
}

resource "nomad_job" "prometheus" {
    jobspec = templatefile("nomad/prometheus.nomad", {
        image_alertmanager = var.images.prom_alertmanager
        image_blackbox = var.images.prom_blackbox
        image_prometheus = var.images.prom_prometheus
        config_prometheus = file("conf/prometheus/prometheus.yml")
        config_rules_house = file("conf/prometheus/house.rules")
        config_rules_node = file("conf/prometheus/node.rules")
        config_rules_prober = file("conf/prometheus/prober.rules")
        config_alertmanager = file("conf/prometheus/alertmanager.yml")
        config_blackbox = file("conf/prometheus/blackbox.yml")
    })
}

resource "nomad_job" "synapse" {
    jobspec = templatefile("nomad/synapse.nomad", {
        image = var.images.synapse
        uids = var.house_uids.synapse
        config = file("conf/synapse.yml")
    })
}

resource "nomad_job" "unifi" {
    jobspec = templatefile("nomad/unifi.nomad", {
        image = var.images.unifi
        uids = var.house_uids.unifi
    })
}
