# The vault_home service account is used by the home Vault server for the KMS
# APIs to auto-unseal.

resource "google_service_account" "vault_home" {
    account_id = "vault-home"
    display_name = "Home Vault"
}

resource "google_service_account_key" "vault_home" {
    service_account_id = google_service_account.vault_home.id
}

# TODO: Fix this to be cleaner somehow
# Write the private key material to a local file, so it can be shoved
# into ansible to put at /etc/vault.d/creds.json on the server.
resource "local_file" "vault_home_gcp_creds" {
    content = base64decode(google_service_account_key.vault_home.private_key)
    filename = "vaultcreds.json"
    file_permission = "0600"
}

# The vault_home key ring contains a single key used for auto-unseal.

resource "google_kms_key_ring" "vault_home" {
    name = "vault-home"
    location = "global"
}

resource "google_kms_crypto_key" "vault_home" {
    name = "seal"
    rotation_period = "100000s"
    key_ring = google_kms_key_ring.vault_home.id
}

resource "google_kms_crypto_key_iam_member" "vault_home_encrypt" {
    crypto_key_id = google_kms_crypto_key.vault_home.id
    member = "serviceAccount:${google_service_account.vault_home.email}"
    role = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
}
