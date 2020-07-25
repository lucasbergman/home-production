provider "nomad" {
    address = "http://localhost:4646"
}

variable "host_root_kludge" {
    default = "/vagrant"
}

resource "nomad_job" "nginx" {
    jobspec = templatefile("nginx.nomad", {
        hostroot = "${var.host_root_kludge}"
    })
}

resource "nomad_job" "grafana" {
    jobspec = file("grafana.nomad")
}

resource "nomad_job" "moneydance" {
    jobspec = file("moneydance.nomad")
}

resource "nomad_job" "plex" {
    jobspec = file("plex.nomad")
}

resource "nomad_job" "prometheus" {
    jobspec = file("prometheus.nomad")
}

resource "nomad_job" "synapse" {
    jobspec = file("synapse.nomad")
}

resource "nomad_job" "unifi" {
    jobspec = file("unifi.nomad")
}
