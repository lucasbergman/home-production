job "prometheus" {
    datacenters = ["house"]
    type = "service"
    vault {
        policies = ["access-secrets"]
    }

    group "monitoring" {
        task "frontend" {
            driver = "docker"
            config {
                image = "${image_prometheus.name}:${image_prometheus.version}"
                mounts = [
                    {
                        type = "bind"
                        target = "/etc/prometheus"
                        source = "local/prometheus"
                        readonly = true
                    },
                    {
                        type = "bind"
                        target = "/prometheus"
                        source = "/var/prometheus"
                    },
                ]
                args = [
                    "--web.listen-address=0.0.0.0:$${NOMAD_PORT_http}",
                    "--config.file=/etc/prometheus/prometheus.yml",
                    "--storage.tsdb.path=/prometheus",
                    "--web.console.libraries=/usr/share/prometheus/console_libraries",
                    "--web.console.templates=/usr/share/prometheus/consoles",
                ]
            }
            template {
                data = <<EOF
${config_prometheus}
EOF
                destination = "local/prometheus/prometheus.yml"
                change_mode = "signal"
                change_signal = "SIGHUP"
            }
            template {
                data = <<EOF
${config_rules_house}
EOF
                destination = "local/prometheus/house.rules"
                change_mode = "signal"
                change_signal = "SIGHUP"
            }
            template {
                data = <<EOF
${config_rules_node}
EOF
                destination = "local/prometheus/node.rules"
                change_mode = "signal"
                change_signal = "SIGHUP"
            }
            template {
                data = <<EOF
${config_rules_prober}
EOF
                destination = "local/prometheus/prober.rules"
                change_mode = "signal"
                change_signal = "SIGHUP"
            }
            template {
                data = <<EOF
${config_rules_ups}
EOF
                destination = "local/prometheus/ups.rules"
                change_mode = "signal"
                change_signal = "SIGHUP"
            }
            service {
                port = "http"
                check {
                    type = "http"
                    path = "/-/healthy"
                    interval = "10s"
                    timeout = "2s"
                }
            }
            resources {
                network {
                    port "http" {}
                }
            }
        }
    }

    group "prober" {
        task "blackbox-exporter" {
            driver = "docker"
            config {
                image = "${image_blackbox.name}:${image_blackbox.version}"
                mounts = [
                    {
                        type = "bind"
                        target = "/etc/blackbox_exporter/config.yml"
                        source = "local/blackbox.yml"
                        readonly = true
                    },
                ]
                args = [
                    "--web.listen-address=0.0.0.0:$${NOMAD_PORT_http}",
                    "--config.file=/etc/blackbox_exporter/config.yml",
                ]
            }
            template {
                data = <<EOF
${config_blackbox}
EOF
                destination = "local/blackbox.yml"
                change_mode = "signal"
                change_signal = "SIGHUP"
            }
            service {
                port = "http"
                check {
                    type = "http"
                    path = "/-/healthy"
                    interval = "10s"
                    timeout = "2s"
                }
            }
            resources {
                network {
                    port "http" {}
                }
            }
        }
    }

    group "alertmanager" {
        task "alertmanager" {
            driver = "docker"
            config {
                image = "${image_alertmanager.name}:${image_alertmanager.version}"
                mounts = [
                    {
                        type = "bind"
                        target = "/etc/alertmanager/alertmanager.yml"
                        source = "local/alertmanager.yml"
                        readonly = true
                    },
                    {
                        type = "bind"
                        target = "/alertmanager"
                        source = "/var/alertmanager"
                    },
                ]
                args = [
                    "--web.listen-address=0.0.0.0:$${NOMAD_PORT_http}",
                    "--config.file=/etc/alertmanager/alertmanager.yml",
                    "--storage.path=/alertmanager",
                ]
            }
            template {
                data = <<EOF
${config_alertmanager}
EOF
                destination = "local/alertmanager.yml"
                change_mode = "signal"
                change_signal = "SIGHUP"
            }
            service {
                port = "http"
                check {
                    type = "http"
                    path = "/-/healthy"
                    interval = "10s"
                    timeout = "2s"
                }
            }
            resources {
                network {
                    port "http" {}
                }
            }
        }
    }
}
