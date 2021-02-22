job "synapse" {
    datacenters = ["house"]
    type = "service"
    vault {
        policies = ["access-secrets"]
    }

    group "synapse" {
        task "synapse" {
            driver = "docker"
            config {
                image = "${image.name}:${image.version}"
                port_map {
                    http = 8008
                }
                mounts = [
                    {
                        type = "bind"
                        target = "/data"
                        source = "/storage/matrix"
                    },
                    {
                        type = "bind"
                        target = "/tls"
                        source = "/storage/tls"
                        readonly = true
                    },
                ]
            }
            template {
                data = <<EOH
UID="{{with secret "secret/synapse"}}{{.Data.uid}}{{end}}"
GID="{{with secret "secret/synapse"}}{{.Data.gid}}{{end}}"
EOH
                destination = "secrets/synapse.env"
                env = true
            }
            env {
                SYNAPSE_SERVER_NAME = "bergman.house"
                SYNAPSE_REPORT_STATS = "yes"
                SYNAPSE_ENABLE_REGISTRATION = "no"
                SYNAPSE_LOG_LEVEL = "INFO"
                SYNAPSE_NO_TLS = "yes"

            }
            service {
                port = "http"
                name = "synapse"
            }
            resources {
                network {
                    port "http" {}
                }
            }
        }
    }
}
