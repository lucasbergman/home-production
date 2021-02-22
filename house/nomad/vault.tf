resource vault_policy "nomad_access_secrets" {
    name = "access-secrets"
    policy = file("access-secrets-policy.hcl")
}

resource vault_policy "nomad_server" {
    name = "nomad-server"
    policy = file("nomad-server-policy.hcl")
}

resource "vault_token_auth_backend_role" "nomad_cluster" {
    role_name = "nomad-cluster"
    allowed_policies = ["access-secrets"]
    orphan = true
    token_explicit_max_ttl = 0
    token_period = 60 * 60 * 24 * 3  // 3 days in seconds
    renewable = true
}
