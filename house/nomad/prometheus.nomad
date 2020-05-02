job "prometheus" {
    datacenters = ["house"]
    type = "service"

    group "monitoring" {
        task "frontend" {
            driver = "docker"
            config {
                image = "prom/prometheus:v2.17.0"
                mounts = [
                    {
                        type = "bind"
                        target = "/etc/prometheus"
                        source = "local/prometheus"
                        readonly = true
                    },
                    {
                        type = "bind"
                        target = "/etc/prometheus-rules"
                        source = "/config/prometheus"
                        readonly = true
                    },
                    {
                        type = "bind"
                        target = "/prometheus"
                        source = "/storage/cluster/prometheus"
                    },
                ]
                args = [
                    "--web.listen-address=0.0.0.0:${NOMAD_PORT_http}",
                    "--config.file=/etc/prometheus/prometheus.yml",
                    "--storage.tsdb.path=/prometheus",
                    "--web.console.libraries=/usr/share/prometheus/console_libraries",
                    "--web.console.templates=/usr/share/prometheus/consoles",
                ]
            }
            template {
                data = <<EOF
global:
  scrape_interval:     30s
  evaluation_interval: 30s
  scrape_timeout:      5s

  external_labels:
    monitor: 'home-monitor'

rule_files:
  - '/etc/prometheus-rules/node.rules'
  - '/etc/prometheus-rules/prober.rules'

alerting:
  alertmanagers:
    - static_configs:
      - targets:
          {{- range service "prometheus-alertmanager-alertmanager" }}
          - '{{ .Address }}:{{ .Port }}'
          {{- end }}

scrape_configs:
  - job_name: 'router'
    static_configs:
      - targets: ['192.168.101.1:9100']
        labels:
          host: router

  - job_name: 'node'
    static_configs:
      - targets:
          {{- range nodes }}
          - '{{ .Address }}:9100'
          {{- end }}
        labels:
          host: hedwig

  - job_name: 'nomad'
    metrics_path: '/v1/metrics'
    params:
      format: [ 'prometheus' ]
    static_configs:
      - targets:
          {{- range nodes }}
          - '{{ .Address }}:4646'
          {{- end }}
        labels:
          host: hedwig

  - job_name: 'smartmouse'
    metrics_path: '/probe'
    params:
      module: ['http_head']
      target: ['https://smartmousetravel.com/']
    static_configs:
      - targets:
          {{- range service "prometheus-prober-blackbox-exporter" }}
          - '{{ .Address }}:{{ .Port }}'
          {{- end }}
EOF
                destination = "local/prometheus/prometheus.yml"
                change_mode = "signal"
                change_signal = "SIGHUP"
            }
            service {
                port = "http"
                check {
                    type = "http"
                    path = "/-/healthy"
                    interval = "10s"
                    timeout = "2s"
                }
            }
            resources {
                network {
                    port "http" {}
                }
            }
        }
    }

    group "prober" {
        task "blackbox-exporter" {
            driver = "docker"
            config {
                image = "prom/blackbox-exporter:v0.16.0"
                mounts = [
                    {
                        type = "bind"
                        target = "/etc/blackbox_exporter/config.yml"
                        source = "local/blackbox.yml"
                        readonly = true
                    },
                ]
                args = [
                    "--web.listen-address=0.0.0.0:${NOMAD_PORT_http}",
                    "--config.file=/etc/blackbox_exporter/config.yml",
                ]
            }
            template {
                source = "/config/prometheus/blackbox.yml"
                destination = "local/blackbox.yml"
                change_mode = "signal"
                change_signal = "SIGHUP"
            }
            service {
                port = "http"
                check {
                    type = "http"
                    path = "/-/healthy"
                    interval = "10s"
                    timeout = "2s"
                }
            }
            resources {
                network {
                    port "http" {}
                }
            }
        }
    }

    group "alertmanager" {
        task "alertmanager" {
            driver = "docker"
            config {
                image = "prom/alertmanager:v0.20.0"
                mounts = [
                    {
                        type = "bind"
                        target = "/etc/alertmanager/alertmanager.yml"
                        source = "/config/prometheus/alertmanager.yml"
                        readonly = true
                    },
                    {
                        type = "bind"
                        target = "/alertmanager"
                        source = "/storage/alertmanager"
                    },
                ]
                args = [
                    "--web.listen-address=0.0.0.0:${NOMAD_PORT_http}",
                    "--config.file=/etc/alertmanager/alertmanager.yml",
                    "--storage.path=/alertmanager",
                ]
            }
            service {
                port = "http"
                check {
                    type = "http"
                    path = "/-/healthy"
                    interval = "10s"
                    timeout = "2s"
                }
            }
            resources {
                network {
                    port "http" {}
                }
            }
        }
    }
}
