#jinja2:block_start_string:'[%', block_end_string:'%]', variable_start_string:'[[', variable_end_string:']]'
ui = true

storage "file" {
    path = "/opt/vault/data"
}

#storage "consul" {
#  address = "127.0.0.1:8500"
#  path    = "vault"
#}

listener "tcp" {
    address = "127.0.0.1:8200"
    tls_disable = 1
}

[% if vault_unseal_gcpckms %]
seal "gcpckms" {
    credentials = "/etc/vault.d/creds.json"
    project = "[[ vault_unseal_gcpckms_project ]]"
    region = "[[ vault_unseal_gcpckms_region ]]"
    key_ring = "[[ vault_unseal_gcpckms_key_ring ]]"
    crypto_key = "[[ vault_unseal_gcpckms_key ]]"
}
[% endif %]
