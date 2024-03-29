job "nginx" {
    datacenters = ["house"]
    group "nginx" {
        task "nginx" {
            driver = "docker"
            config {
                image = "${image.name}:${image.version}"
                network_mode = "host"
                port_map {
                    http = 80
                    https = 443
                }
                mounts = [
                    {
                        type = "bind"
                        target = "/etc/nginx/conf.d"
                        source = "local"
                        readonly = true
                    },
                    {
                        type = "bind"
                        target = "/tls"
                        source = "/storage/tls/letsencrypt"
                        readonly = true
                    },
                    {
                        type = "bind"
                        target = "/html"
                        source = "/var/www/html"
                        readonly = true
                    },
                ]
            }
            template {
                data = <<EOF
${config_default}
EOF
                destination = "local/default.conf"
                change_mode = "signal"
                change_signal = "SIGHUP"
            }
            template {
                data = <<EOF
${config_mon}
EOF
                destination = "local/mon.conf"
                change_mode = "signal"
                change_signal = "SIGHUP"
            }
            template {
                data = <<EOF
${config_grafana}
EOF
                destination = "local/grafana.conf"
                change_mode = "signal"
                change_signal = "SIGHUP"
            }
            template {
                data = <<EOF
${config_plex}
EOF
                destination = "local/plex.conf"
                change_mode = "signal"
                change_signal = "SIGHUP"
            }
            template {
                data = <<EOF
${config_hass}
EOF
                destination = "local/hass.conf"
                change_mode = "signal"
                change_signal = "SIGHUP"
            }
            resources {
                network {
                    port "http" {
                        static = "80"
                    }
                    port "https" {
                        static = "443"
                    }
                }
            }
            service {
                name = "nginx"
                port = "http"
                check {
                    type = "http"
                    path = "/health"
                    interval = "10s"
                    timeout = "1s"
                }
            }
        }
    }
}
