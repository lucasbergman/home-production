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
                        source = "local/configuration.yaml"
                    },
                    {
                        type = "bind"
                        target = "/config/automations.yaml"
                        source = "local/automations.yaml"
                    },
                ]
            }
            template {
                data = <<EOF
${config_main}
EOF
                destination = "local/configuration.yaml"
                change_mode = "restart"
            }
            template {
                data = <<EOF
${config_automation}
EOF
                destination = "local/automations.yaml"
                change_mode = "restart"

                # Swap delimiters to avoid collision with Home Assistant Jinja2
                left_delimiter = "[["
                right_delimiter = "]]"
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
