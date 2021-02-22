job "moneydance" {
    datacenters = ["house"]
    type = "service"
    vault {
        policies = ["access-secrets"]
    }

    group "moneydance" {
        task "moneydance" {
            driver = "docker"
            config {
                image = "dorowu/ubuntu-desktop-lxde-vnc:bionic"
                port_map {
                    http = 80
                }
                mounts = [
                    {
                        type = "bind"
                        target = "/dev/shm"
                        source = "/dev/shm"
                    },
                    {
                        type = "bind"
                        target = "/moneydance"
                        source = "/storage/users/moneydance"
                    },
                ]
            }
            template {
                data = <<EOH
MONEYDANCE_UID="{{with secret "secret/moneydance"}}{{.Data.uid}}{{end}}"
HTTP_PASSWORD="{{with secret "secret/moneydance"}}{{.Data.password}}{{end}}"
EOH
                destination = "secrets/moneydance.env"
                env = true
            }
            service {
                port = "http"
                name = "moneydance"
            }
            resources {
                cpu = 500  # MHz
                memory = 1024  # MiB = 1 GiB
                network {
                    port "http" {}
                }
            }
        }
    }
}
