job "apcupsd_exporter" {
    datacenters = ["house"]
    type = "service"

    group "apcupsd_exporter" {
        task "apcupsd_exporter" {
            driver = "docker"
            config {
                image = "${image.name}:${image.version}"
                network_mode = "host"
                command = "/go/bin/apcupsd_exporter"
                args = [
                    "-telemetry.addr=:$${NOMAD_PORT_http}",
                ]
            }
            service {
                port = "http"
                name = "apcupsd-exporter"
            }
            resources {
                cpu = 200  # MHz
                memory = 256  # MiB
                network {
                    port "http" {}
                }
            }
        }
    }
}
