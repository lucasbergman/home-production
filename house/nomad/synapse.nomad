job "synapse" {
    datacenters = ["house"]
    type = "service"

    group "synapse" {
        task "synapse" {
            driver = "docker"
            config {
                image = "matrixdotorg/synapse:v1.19.3"
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
                source = "/config/synapse.env"
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
