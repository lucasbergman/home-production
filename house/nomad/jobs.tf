resource "nomad_job" "nginx" {
    jobspec = file("nginx.nomad")
}

resource "nomad_job" "grafana" {
    jobspec = templatefile("grafana.nomad", {image = var.images.grafana})
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
    })
}

resource "nomad_job" "synapse" {
    jobspec = templatefile("synapse.nomad", {image = var.images.synapse})
}

resource "nomad_job" "unifi" {
    jobspec = templatefile("unifi.nomad", {image = var.images.unifi})
}
