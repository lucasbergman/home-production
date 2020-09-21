job "prometheus" {
    datacenters = ["house"]
    type = "service"

    group "monitoring" {
        task "frontend" {
            driver = "docker"
            config {
                image = "${image_prometheus.name}:${image_prometheus.version}"
                mounts = [
                    {
                        type = "bind"
                        target = "/etc/prometheus"
                        source = "local/prometheus"
                        readonly = true
                    },
                    {
                        type = "bind"
                        target = "/prometheus"
                        source = "/storage/cluster/prometheus"
                    },
                ]
                args = [
                    "--web.listen-address=0.0.0.0:$${NOMAD_PORT_http}",
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
  - '/etc/prometheus/node.rules'
  - '/etc/prometheus/prober.rules'

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
            template {
                data = <<EOF
groups:
  - name: node_net
    rules:
      - record: node:receive_bytes
        expr: node_network_receive_bytes{device=~"^(en|eth).*"}
      - record: node:transmit_bytes
        expr: node_network_transmit_bytes{device=~"^(en|eth).*"}
      - record: node:receive_bytes:rate5m
        expr: rate(node:receive_bytes[5m])
      - record: node:transmit_bytes:rate5m
        expr: rate(node:transmit_bytes[5m])

  - name: node_fs
    rules:
      - record: node:filesystem_avail
        expr: node_filesystem_avail
      - record: node:filesystem_avail:fraction
        expr: node_filesystem_avail / node_filesystem_size

  - name: node_cpu
    rules:
      - record: node:cpu:rate1m
        expr: sum(rate(node_cpu[1m])) by (host, mode)
      - record: node:cpu:rate5m
        expr: sum(rate(node_cpu[5m])) by (host, mode)

  - name: node_router
    rules:
    - record: router:edge:receive_bytes
      expr: node_network_receive_bytes{device="eth0",host="router"}
    - record: router:edge:transmit_bytes
      expr: node_network_transmit_bytes{device="eth0",host="router"}
    - record: router:edge:receive_bytes:rate5m
      expr: rate(router:edge:receive_bytes[5m])
    - record: router:edge:transmit_bytes:rate5m
      expr: rate(router:edge:transmit_bytes[5m])

  - name: nomad_resources
    rules:
      - record: nomad:alloc:cpu_total_fraction
        expr: sum without (alloc_id) (nomad_client_allocs_cpu_total_percent/100)
      - record: nomad:alloc:mem_used
        expr: sum without (alloc_id) (nomad_client_allocs_memory_usage)
EOF
                destination = "local/prometheus/node.rules"
                change_mode = "signal"
                change_signal = "SIGHUP"
            }
            template {
                data = <<EOF
groups:
  - name: prober_smartmouse
    rules:
    - record: smartmouse:probe_http_duration_seconds
      expr: probe_http_duration_seconds{job="smartmouse"}
    - record: smartmouse:prober_duration_seconds
      expr: probe_duration_seconds{job="smartmouse"}
    - record: smartmouse:prober_success
      expr: probe_success{job="smartmouse"}
    - alert: SmartmouseProberFailed
      expr: smartmouse:prober_success == 0
      for: 5m
      labels:
        severity: page
      annotations:
        summary: 'Main smartmousetravel.com prober failed'
        description: 'Main smartmousetravel.com prober has failed for >5m'
EOF
                destination = "local/prometheus/prober.rules"
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
                image = "${image_blackbox.name}:${image_blackbox.version}"
                mounts = [
                    {
                        type = "bind"
                        target = "/etc/blackbox_exporter/config.yml"
                        source = "local/blackbox.yml"
                        readonly = true
                    },
                ]
                args = [
                    "--web.listen-address=0.0.0.0:$${NOMAD_PORT_http}",
                    "--config.file=/etc/blackbox_exporter/config.yml",
                ]
            }
            template {
                data = <<EOF
modules:
  http_head:
    prober: http
    timeout: 5s
    http:
      method: HEAD
      fail_if_not_ssl: true
EOF
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
                image = "${image_alertmanager.name}:${image_alertmanager.version}"
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
                    "--web.listen-address=0.0.0.0:$${NOMAD_PORT_http}",
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
