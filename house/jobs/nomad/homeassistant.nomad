job "homeassistant" {
    datacenters = ["house"]
    type = "service"
    vault {
        policies = ["access-secrets"]
    }

    group "homeassistant" {
        task "homeassistant" {
            driver = "docker"
            config {
                image = "${image.name}:${image.version}"
                network_mode = "host"
                mounts = [
                    {
                        type = "bind"
                        target = "/config"
                        source = "/storage/homeassistant"
                    },
                    {
                        type = "bind"
                        target = "/config/configuration.yaml"
                        source = "local/conf.yml"
                    },
                ]
            }
            template {
                data = <<EOF
${config}
EOF
                destination = "local/conf.yml"
                change_mode = "restart"
            }
            service {
                port = "http"
                name = "homeassistant"
            }
            resources {
                network {
                    port "http" {}
                }
            }
        }
    }
}
