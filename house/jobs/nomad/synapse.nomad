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
                        target = "/data/homeserver.yaml"
                        source = "local/synapse.yml"
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
                data = <<EOF
${config}
EOF
                destination = "local/synapse.yml"
                change_mode = "signal"
                change_signal = "SIGHUP"
            }
            env {
                UID = "${uids.uid}"
                GID = "${uids.gid}"
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
