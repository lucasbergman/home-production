#jinja2:variable_start_string:'[%', variable_end_string:'%]'
datacenter = "house"
data_dir = "/storage/cluster/nomad"
bind_addr = "{{ GetInterfaceIP \"[% control_plane_interface %]\" }}"

telemetry {
    disable_hostname = true
    collection_interval = "10s"
    publish_allocation_metrics = true
    publish_node_metrics = true
    prometheus_metrics = true
}

server {
    enabled = true
    bootstrap_expect = 1
}

client {
    enabled = true
    network_interface = "[% control_plane_interface %]"
}
