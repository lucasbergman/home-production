#jinja2:variable_start_string:'[%', variable_end_string:'%]'
datacenter = "house"
data_dir = "/storage/cluster/consul"
# TODO: generate proper key and encrypt
encrypt = "Luj2FZWwlt8475wD1WtwUQ=="

server = true
bootstrap_expect = 1
bind_addr = "{{ GetInterfaceIP \"[% control_plane_interface %]\" }}"
