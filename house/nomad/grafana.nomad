job "grafana" {
    datacenters = ["house"]
    type = "service"

    group "grafana" {
        task "grafana" {
            driver = "docker"
            config {
                image = "grafana/grafana:7.1.1"
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
instance_name = grafana.bergman.house

[server]
domain = grafana.bergman.house
root_url = https://grafana.bergman.house
http_port = {{ env "NOMAD_PORT_http" }}

[users]
allow_sign_up = false

[smtp]
enabled = true
host = bergmans.us:25
;TODO set this up properly
;user =
;password =
from_address = grafana@bergmans.us
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
