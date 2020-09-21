#jinja2:block_start_string:'[%', block_end_string:'%]', variable_start_string:'[[', variable_end_string:']]'
datacenter = "[[ nomad_datacenter ]]"
data_dir = "[[ nomad_storage_directory ]]"
[% if nomad_interface|length %]
bind_addr = "{{ GetInterfaceIP \"[[ nomad_interface ]]\" }}"
[% endif %]

telemetry {
    disable_hostname = true
    collection_interval = "10s"
    publish_allocation_metrics = true
    publish_node_metrics = true
    prometheus_metrics = true
}

server {
    enabled = true
    bootstrap_expect = [[ nomad_bootstrap_nodes ]]
}

[% if use_digitalocean %]
server_join {
    retry_join = [
        "provider=digitalocean region=[[ digitalocean_region ]] tag_name=[[ nomad_digitalocean_tag ]] api_token=[[ digitalocean_token ]]",
    ]
}
[% endif %]

client {
    enabled = true
    network_interface = "[[ nomad_interface ]]"
}

plugin "docker" {
    config {
        volumes {
            enabled = true
        }
    }
}
