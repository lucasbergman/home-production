resource "google_storage_bucket" "backup" {
  name          = "bergmans-services-backup"
  location      = "US"
  storage_class = "NEARLINE"

  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
}
