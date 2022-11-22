resource "linode_stackscript" "write_gcp_creds" {
  label       = "write_gcp_creds"
  description = "Writes a GCP credentials file"
  script      = file("instancesetup.sh")
  images      = ["any/all"]
  is_public   = false
}
