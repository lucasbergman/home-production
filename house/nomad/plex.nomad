job "plex" {
    datacenters = ["house"]
    type = "service"

    group "plex" {
        task "plex" {
            driver = "docker"
            config {
                image = "plexinc/pms-docker:1.19.4.2935-79e214ead"
                network_mode = "host"
                mounts = [
                    {
                        type = "bind"
                        target = "/config"
                        source = "/storage/media/plex-system"
                    },
                    {
                        type = "bind"
                        target = "/transcode"
                        source = "/storage/media/plex-transcode"
                    },
                    {
                        type = "bind"
                        target = "/storage/media/plex"
                        source = "/storage/media/plex"
                        readonly = true
                    },
                ]
            }
            template {
                source = "/config/plex.env"
                destination = "secrets/plex.env"
                env = true
            }
            service {
                port = "http"
                name = "plex"
            }
            resources {
                cpu = 1000  # MHz
                memory = 1024  # MiB
                network {
                    port "http" {
                        static = "32400"
                    }
                    port "dlna_1" {
                        static = "1900"
                    }
                    port "dlna_2" {
                        static = "32469"
                    }
                    port "plex_companion" {
                        static = "3005"
                    }
                    port "roku_plex_companion" {
                        static = "8324"
                    }
                    port "discovery_1" {
                        static = "32410"
                    }
                    port "discovery_2" {
                        static = "32412"
                    }
                    port "discovery_3" {
                        static = "32413"
                    }
                    port "discovery_4" {
                        static = "32414"
                    }
                }
            }
        }
    }
}
