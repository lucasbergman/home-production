resource "google_service_account" "instance_snowball" {
  account_id   = "instance-snowball"
  display_name = "Snowball VM instance account"
}

resource "google_project_iam_member" "snowball_acme_dns" {
  project = var.gcp_project
  role    = google_project_iam_custom_role.acme_dns.name
  member  = "serviceAccount:${google_service_account.instance_snowball.email}"
}

resource "google_service_account_key" "instance_snowball" {
  service_account_id = google_service_account.instance_snowball.id
}

resource "linode_instance" "snowball" {
  label  = "snowball"
  type   = "g6-standard-2"
  region = "us-central"
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
  image           = "linode/ubuntu22.04"
  authorized_keys = [chomp(file("ssh/home-desktop.pub"))]
  stackscript_id  = linode_stackscript.write_gcp_creds.id
  stackscript_data = {
    "creds" = google_service_account_key.instance_snowball.private_key
  }
}

resource "linode_volume" "snowball_data" {
  label  = "snowball-data"
  region = "us-central"
  size   = 10 # GB
}

resource "linode_instance_config" "snowball" {
  linode_id = linode_instance.snowball.id
  label     = "ubuntu"
  booted    = true

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

resource "google_dns_record_set" "bergmans_a_mumble" {
  managed_zone = google_dns_managed_zone.bergmans.name
  name         = "mumble.bergmans.us."
  type         = "A"
  rrdatas      = [linode_instance.snowball.ip_address]
  ttl          = 300
}
