#jinja2:block_start_string:'[%', block_end_string:'%]', variable_start_string:'[[', variable_end_string:']]'
[% if nomad_datacenter|length %]
datacenter = "[[ nomad_datacenter ]]"
[% endif %]
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
[% if nomad_server_enable|bool %]
    enabled = true
[% endif %]
    bootstrap_expect = [[ nomad_bootstrap_nodes ]]
}

client {
    enabled = true
[% if nomad_interface|length %]
    network_interface = "[[ nomad_interface ]]"
[% endif %]
}

plugin "docker" {
    config {
        volumes {
            enabled = true
        }
    }
}
