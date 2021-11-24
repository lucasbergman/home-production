resource "google_service_account" "rclone_home" {
    account_id = "rclone-home"
    display_name = "Home RClone"
}

resource "google_service_account_key" "rclone_home" {
    service_account_id = google_service_account.rclone_home.id
}

# TODO: Fix this to be cleaner somehow
# Write the private key material to a local file, so it can be shoved
# into ansible to put into a JSON file on the server.
resource "local_file" "rclone_home_gcp_creds" {
    content = base64decode(google_service_account_key.rclone_home.private_key)
    filename = "rclonecreds.json"
    file_permission = "0600"
}

resource "google_storage_bucket" "home_backup" {
    name = "rclone-home-backup"
    location = "US"
    storage_class = "NEARLINE"
    uniform_bucket_level_access = true
    force_destroy = true

    lifecycle_rule {
        condition {
            age = 90  # days
        }
        action {
            type = "Delete"
        }
    }
}

resource "google_storage_bucket_iam_binding" "home_backup_binding" {
    bucket = google_storage_bucket.home_backup.name
    # TODO: import this role into terraform
    role = "projects/bergmans-services/roles/CloudStorageBackup"
    members = ["serviceAccount:${google_service_account.rclone_home.email}"]
}
