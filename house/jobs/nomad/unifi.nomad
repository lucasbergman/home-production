job "unifi" {
    datacenters = ["house"]
    type = "service"

    group "unifi" {
        task "controller" {
            driver = "docker"
            config {
                image = "${image.name}:${image.version}"
                network_mode = "host"
                mounts = [
                    {
                        type = "bind"
                        target = "/config"
                        source = "/var/unifi"
                    },
                ]
            }
            env {
                PUID = "${uids.uid}"
                PGID = "${uids.gid}"
            }
            service {
                port = "ui"
                name = "unifi"
            }
            resources {
                cpu = 1000  # MHz
                memory = 1024  # MiB
                network {
                    port "stun" {
                        static = "3478"
                    }
                    port "ap_discovery" {
                        static = "10001"
                    }
                    port "device_comm" {
                        static = "8080"
                    }
                    port "ui" {
                        static = "8443"
                    }
                }
            }
        }
    }
}
