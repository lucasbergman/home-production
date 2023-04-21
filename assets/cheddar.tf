# Create an instance-level GCP service account and make it a member of
# IAM roles to enable DNS writes for ACME-generated certificates, log
# shipping, and writing backups.

resource "google_service_account" "instance_cheddar" {
  account_id   = "instance-cheddar"
  display_name = "Cheddar VM instance account"
}

resource "google_project_iam_member" "cheddar_acme_dns" {
  project = var.gcp_project
  role    = google_project_iam_custom_role.acme_dns.name
  member  = "serviceAccount:${google_service_account.instance_cheddar.email}"
}

resource "google_project_iam_member" "cheddar_log_writer" {
  project = var.gcp_project
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.instance_cheddar.email}"
}

resource "google_storage_bucket_iam_member" "cheddar_backup" {
  bucket = google_storage_bucket.backup.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.instance_cheddar.email}"
}

resource "google_service_account_key" "instance_cheddar" {
  service_account_id = google_service_account.instance_cheddar.id
}

# TODO: The snapshot_id value is from a manually generated snapshot.
# I created a new instance in the web interface, installed NixOS by
# hand, and took a snapshot of the result. That's toilsome, but one
# thing at a time.

resource "vultr_instance" "cheddar" {
  plan        = "vc2-2c-4gb"
  region      = "ord"
  snapshot_id = "3addf0f7-9daa-4ae5-a68d-0a308c9c221a"
  label       = "cheddar"
  hostname    = "cheddar.bergmans.us"

  enable_ipv6      = true
  backups          = "disabled"
  ddos_protection  = false
  activation_email = true
}

resource "vultr_block_storage" "cheddar_data" {
  size_gb              = 40
  region               = "ord"
  attached_to_instance = vultr_instance.cheddar.id
  block_type           = "storage_opt"
  live                 = true
}

resource "google_dns_record_set" "bergmans_a_cheddar" {
  managed_zone = google_dns_managed_zone.bergmans.name
  name         = "${vultr_instance.cheddar.hostname}."
  type         = "A"
  rrdatas      = [vultr_instance.cheddar.main_ip]
  ttl          = 300
}

resource "google_dns_record_set" "bergmans_aaaa_cheddar" {
  managed_zone = google_dns_managed_zone.bergmans.name
  name         = "${vultr_instance.cheddar.hostname}."
  type         = "AAAA"
  rrdatas      = [vultr_instance.cheddar.v6_main_ip]
  ttl          = 300
}

resource "google_dns_record_set" "bergmans_a_mumble" {
  managed_zone = google_dns_managed_zone.bergmans.name
  name         = "mumble.bergmans.us."
  type         = "A"
  rrdatas      = [vultr_instance.cheddar.main_ip]
  ttl          = 300
}

resource "google_dns_record_set" "bergmans_aaaa_mumble" {
  managed_zone = google_dns_managed_zone.bergmans.name
  name         = "mumble.bergmans.us."
  type         = "AAAA"
  rrdatas      = [vultr_instance.cheddar.v6_main_ip]
  ttl          = 300
}
