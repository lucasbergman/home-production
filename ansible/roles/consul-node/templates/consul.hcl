#jinja2:variable_start_string:'[%', variable_end_string:'%]'
datacenter = "[% consul_datacenter %]"
data_dir = "[% consul_storage_directory %]"
# TODO: generate proper key and encrypt
encrypt = "Luj2FZWwlt8475wD1WtwUQ=="

server = true
bootstrap_expect = 1
bind_addr = "{{ GetInterfaceIP \"[% consul_interface %]\" }}"
