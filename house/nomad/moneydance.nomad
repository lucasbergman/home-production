job "moneydance" {
    datacenters = ["house"]
    type = "service"

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
                source = "/config/moneydance.env"
                destination = "secrets/moneydance.env"
                env = true
            }
            service {
                port = "http"
                name = "moneydance"
            }
            resources {
                network {
                    port "http" {}
                }
            }
        }
    }
}
