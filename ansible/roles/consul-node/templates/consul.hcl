#jinja2:block_start_string:'[%', block_end_string:'%]', variable_start_string:'[[', variable_end_string:']]'
[% if consul_datacenter|length %]
datacenter = "[[ consul_datacenter ]]"
[% endif %]
data_dir = "[[ consul_storage_directory ]]"
[% if consul_gossip_encrypt_key|string|length %]
encrypt = "[[ consul_gossip_encrypt_key ]]"
[% endif %]

[% if consul_server_enable|bool %]
server = true
[% endif %]
bootstrap_expect = [[ consul_bootstrap_nodes ]]
[% if consul_interface|length %]
bind_addr = "{{ GetInterfaceIP \"[[ consul_interface ]]\" }}"
[% endif %]
[% if consul_retry_join|length %]
retry_join = [
    "[[ consul_retry_join ]]",
]
[% endif %]
