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
