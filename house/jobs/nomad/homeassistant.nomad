job "homeassistant" {
    datacenters = ["house"]
    type = "service"

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
                        target = "/config/http.yml"
                        source = "local/http.yml"
                    },
                ]
            }
            template {
                data = <<EOF
${config}
EOF
                destination = "local/http.yml"
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
