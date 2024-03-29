resource "google_service_account" "instance_snowball" {
  account_id   = "instance-snowball"
  display_name = "Snowball VM instance account"
}

resource "google_project_iam_member" "snowball_acme_dns" {
  project = var.gcp_project
  role    = google_project_iam_custom_role.acme_dns.name
  member  = "serviceAccount:${google_service_account.instance_snowball.email}"
}

resource "google_project_iam_member" "snowball_log_writer" {
  project = var.gcp_project
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.instance_snowball.email}"
}

resource "google_storage_bucket_iam_member" "snowball_backup" {
  bucket = google_storage_bucket.backup.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.instance_snowball.email}"
}

resource "google_service_account_key" "instance_snowball" {
  service_account_id = google_service_account.instance_snowball.id
}

resource "linode_instance" "snowball" {
  label  = "snowball"
  type   = var.linode_type
  region = var.linode_region
}

resource "linode_instance_disk" "snowball_swap" {
  label      = "swap"
  linode_id  = linode_instance.snowball.id
  size       = 1024
  filesystem = "swap"
}

resource "linode_instance_disk" "snowball_boot" {
  label           = "boot"
  linode_id       = linode_instance.snowball.id
  size            = linode_instance.snowball.specs.0.disk - linode_instance_disk.snowball_swap.size
  image           = var.linode_image
  authorized_keys = [chomp(file("ssh/home-desktop.pub"))]
  stackscript_id  = linode_stackscript.write_gcp_creds.id
  stackscript_data = {
    "creds" = google_service_account_key.instance_snowball.private_key
  }
}

resource "linode_volume" "snowball_data" {
  label  = "snowball-data"
  region = var.linode_region
  size   = 10 # GB
}

resource "linode_instance_config" "snowball" {
  linode_id = linode_instance.snowball.id
  label     = "ubuntu"
  booted    = true
  kernel    = "linode/grub2" # use the distro kernel, not Linode's

  devices {
    sda {
      disk_id = linode_instance_disk.snowball_boot.id
    }
    sdb {
      disk_id = linode_instance_disk.snowball_swap.id
    }
    sdc {
      volume_id = linode_volume.snowball_data.id
    }
  }
}

resource "google_dns_record_set" "bergmans_a_snowball" {
  managed_zone = google_dns_managed_zone.bergmans.name
  name         = "snowball.bergmans.us."
  type         = "A"
  rrdatas      = [linode_instance.snowball.ip_address]
  ttl          = 300
}

resource "google_dns_record_set" "bergmans_aaaa_snowball" {
  managed_zone = google_dns_managed_zone.bergmans.name
  name         = "snowball.bergmans.us."
  type         = "AAAA"
  rrdatas      = [split("/", linode_instance.snowball.ipv6)[0]]
  ttl          = 300
}

resource "google_dns_record_set" "bergmans_a_dash" {
  managed_zone = google_dns_managed_zone.bergmans.name
  name         = "dash.bergmans.us."
  type         = "A"
  rrdatas      = [linode_instance.snowball.ip_address]
  ttl          = 300
}

resource "google_dns_record_set" "bergmans_aaaa_dash" {
  managed_zone = google_dns_managed_zone.bergmans.name
  name         = "dash.bergmans.us."
  type         = "AAAA"
  rrdatas      = [split("/", linode_instance.snowball.ipv6)[0]]
  ttl          = 300
}

resource "google_dns_record_set" "bergmans_a_mumble" {
  managed_zone = google_dns_managed_zone.bergmans.name
  name         = "mumble.bergmans.us."
  type         = "A"
  rrdatas      = [linode_instance.snowball.ip_address]
  ttl          = 300
}

resource "google_dns_record_set" "bergmans_aaaa_mumble" {
  managed_zone = google_dns_managed_zone.bergmans.name
  name         = "mumble.bergmans.us."
  type         = "AAAA"
  rrdatas      = [split("/", linode_instance.snowball.ipv6)[0]]
  ttl          = 300
}

resource "google_dns_record_set" "bergmanhouse_a_matrix" {
  managed_zone = google_dns_managed_zone.bergmanhouse.name
  name         = "matrix.bergman.house."
  type         = "A"
  rrdatas      = [linode_instance.snowball.ip_address]
  ttl          = 300
}

resource "google_dns_record_set" "bergmanhouse_aaaa_matrix" {
  managed_zone = google_dns_managed_zone.bergmanhouse.name
  name         = "matrix.bergman.house."
  type         = "AAAA"
  rrdatas      = [split("/", linode_instance.snowball.ipv6)[0]]
  ttl          = 300
}

resource "google_dns_record_set" "bergmans_a_smtp" {
  managed_zone = google_dns_managed_zone.bergmans.name
  name         = "smtp.bergmans.us."
  type         = "A"
  rrdatas      = [linode_instance.snowball.ip_address]
  ttl          = 300
}

resource "google_dns_record_set" "bergmans_aaaa_smtp" {
  managed_zone = google_dns_managed_zone.bergmans.name
  name         = "smtp.bergmans.us."
  type         = "AAAA"
  rrdatas      = [split("/", linode_instance.snowball.ipv6)[0]]
  ttl          = 300
}

resource "google_dns_record_set" "bergmans_a_pop" {
  managed_zone = google_dns_managed_zone.bergmans.name
  name         = "pop.bergmans.us."
  type         = "A"
  rrdatas      = [linode_instance.snowball.ip_address]
  ttl          = 300
}

resource "google_dns_record_set" "bergmans_aaaa_pop" {
  managed_zone = google_dns_managed_zone.bergmans.name
  name         = "pop.bergmans.us."
  type         = "AAAA"
  rrdatas      = [split("/", linode_instance.snowball.ipv6)[0]]
  ttl          = 300
}
