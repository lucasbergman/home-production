job "grafana" {
    datacenters = ["house"]
    type = "service"

    group "grafana" {
        task "grafana" {
            driver = "docker"
            config {
                image = "${image.name}:${image.version}"
                mounts = [
                    {
                        type = "bind"
                        target = "/etc/grafana/grafana.ini"
                        source = "local/grafana.ini"
                        readonly = true
                    },
                    {
                        type = "bind"
                        target = "/var/lib/grafana"
                        source = "/storage/cluster/grafana"
                    },
                ]
                args = [
                ]
            }
            template {
                data = <<EOF
${config_grafana}
EOF
                destination = "local/grafana.ini"
                change_mode = "restart"
            }
            service {
                port = "http"
                name = "grafana"
                check {
                    type = "http"
                    path = "/api/health"
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
