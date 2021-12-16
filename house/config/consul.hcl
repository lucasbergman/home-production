#jinja2:block_start_string:'[%', block_end_string:'%]', variable_start_string:'[[', variable_end_string:']]'
datacenter = "house"
data_dir = "[[ consul_storage_directory ]]"
server = true
bootstrap_expect = 1
bind_addr = "{{ GetInterfaceIP \"enp7s0\" }}"
