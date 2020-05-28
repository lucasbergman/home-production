job "nginx" {
    datacenters = ["house"]
    group "nginx" {
        task "nginx" {
            driver = "docker"
            config {
                image = "nginx"
                port_map {
                    http = 80
                    https = 443
                    matrix_http = 8448
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
server {
  listen 80 default_server;
  listen 443 default_server ssl;
  server_name bergman.house;
  ssl_certificate /tls/live/bergman.house/fullchain.pem;
  ssl_certificate_key /tls/live/bergman.house/privkey.pem;
  location /.well-known/ {
    root /html;
  }
  location /health {
    access_log off;
    return 200 "ok";
  }
  location = /inform {
    access_log off;  # Don't log UniFi spam
    return 404;
  }
  location / {
    return 404;
  }
}
EOF
                destination = "local/default.conf"
                change_mode = "signal"
                change_signal = "SIGHUP"
            }
            template {
                data = <<EOF
upstream prometheus {
{{- range service "prometheus-monitoring-frontend" }}
  server {{ .Address }}:{{ .Port }};
{{ else }}server 127.0.0.1:65535;
{{- end -}}
}

server {
  listen 80;
  listen 443 ssl;
  server_name mon.bergman.house;
  ssl_certificate /tls/live/mon.bergman.house/fullchain.pem;
  ssl_certificate_key /tls/live/mon.bergman.house/privkey.pem;
  location /.well-known/ {
    root /html;
  }
  location / {
    if ($scheme != "https") {
      return 301 https://$host$request_uri;
    }
    proxy_pass http://prometheus;
  }
}
EOF
                destination = "local/mon.conf"
                change_mode = "signal"
                change_signal = "SIGHUP"
            }
            template {
                data = <<EOF
upstream grafana {
{{- range service "grafana" }}
  server {{ .Address }}:{{ .Port }};
{{ else }}server 127.0.0.1:65535;
{{- end -}}
}

server {
  listen 80;
  listen 443 ssl;
  server_name grafana.bergman.house;
  ssl_certificate /tls/live/grafana.bergman.house/fullchain.pem;
  ssl_certificate_key /tls/live/grafana.bergman.house/privkey.pem;
  location /.well-known/ {
    root /html;
  }
  location / {
    if ($scheme != "https") {
      return 301 https://$host$request_uri;
    }
    proxy_pass http://grafana;
  }
}
EOF
                destination = "local/grafana.conf"
                change_mode = "signal"
                change_signal = "SIGHUP"
            }
            template {
                data = <<EOF
upstream moneydance {
{{- range service "moneydance" }}
  server {{ .Address }}:{{ .Port }};
{{ else }}server 127.0.0.1:65535;
{{- end -}}
}

server {
  listen 80;
  listen 443 ssl;
  server_name moneydance.bergman.house;
  ssl_certificate /tls/live/moneydance.bergman.house/fullchain.pem;
  ssl_certificate_key /tls/live/moneydance.bergman.house/privkey.pem;
  location /.well-known/ {
    root /html;
  }
  location / {
    if ($scheme != "https") {
      return 301 https://$host$request_uri;
    }
    proxy_pass http://moneydance;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
  }
}
EOF
                destination = "local/moneydance.conf"
                change_mode = "signal"
                change_signal = "SIGHUP"
            }
            template {
                data = <<EOF
upstream synapse {
{{- range service "synapse" }}
  server {{ .Address }}:{{ .Port }};
{{ else }}server 127.0.0.1:65535;
{{- end -}}
}

server {
  listen 443 ssl;
  listen 8448 ssl;
  server_name matrix.bergman.house;
  ssl_certificate /tls/live/matrix.bergman.house/fullchain.pem;
  ssl_certificate_key /tls/live/matrix.bergman.house/privkey.pem;
  location /.well-known/ {
    root /html;
  }
  location /_matrix {
    if ($scheme != "https") {
      return 301 https://$host$request_uri;
    }
    proxy_pass http://synapse;
    proxy_set_header X-Forwarded-For $remote_addr;
  }
  location / {
    return 404;
  }
}
EOF
                destination = "local/synapse.conf"
                change_mode = "signal"
                change_signal = "SIGHUP"
            }
            template {
                data = <<EOF
upstream plex {
{{- range service "plex" }}
  server {{ .Address }}:{{ .Port }};
{{ else }}server 127.0.0.1:65535;
{{- end -}}
}

server {
  listen 80;
  listen 443 ssl;
  server_name plex.bergman.house;
  ssl_certificate /tls/live/plex.bergman.house/fullchain.pem;
  ssl_certificate_key /tls/live/plex.bergman.house/privkey.pem;
  location /.well-known/ {
    root /html;
  }
  location / {
    if ($scheme != "https") {
      return 301 https://$host$request_uri;
    }
    proxy_pass http://plex;
    proxy_set_header X-Forwarded-For $remote_addr;
  }
}
EOF
                destination = "local/plex.conf"
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
                    port "matrix_http" {
                        static = "8448"
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
