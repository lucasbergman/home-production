resource "nomad_job" "nginx" {
    jobspec = templatefile("nginx.nomad", {
        config_default = file("conf/nginx/default.conf")
        config_mon = file("conf/nginx/mon.conf")
        config_grafana = file("conf/nginx/grafana.conf")
        config_moneydance = file("conf/nginx/moneydance.conf")
        config_synapse = file("conf/nginx/synapse.conf")
        config_plex = file("conf/nginx/plex.conf")
    })
}

resource "nomad_job" "grafana" {
    jobspec = templatefile("grafana.nomad", {
        image = var.images.grafana
        config_grafana = file("conf/grafana.ini")
    })
}

resource "nomad_job" "moneydance" {
    jobspec = file("moneydance.nomad")
}

resource "nomad_job" "plex" {
    jobspec = templatefile("plex.nomad", {image = var.images.plex})
}

resource "nomad_job" "prometheus" {
    jobspec = templatefile("prometheus.nomad", {
        image_alertmanager = var.images.prom_alertmanager
        image_blackbox = var.images.prom_blackbox
        image_prometheus = var.images.prom_prometheus
        config_prometheus = file("conf/prometheus/prometheus.yml")
        config_rules_node = file("conf/prometheus/node.rules")
        config_rules_prober = file("conf/prometheus/prober.rules")
        config_blackbox = file("conf/prometheus/blackbox.yml")
    })
}

resource "nomad_job" "synapse" {
    jobspec = templatefile("synapse.nomad", {image = var.images.synapse})
}

resource "nomad_job" "unifi" {
    jobspec = templatefile("unifi.nomad", {image = var.images.unifi})
}
