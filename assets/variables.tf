variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "aws_access_key_id" {
  description = "AWS access key"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
}

variable "gcp_project" {
  description = "GCP project name"
  type        = string
  default     = "bergmans-services"
}

variable "linode_token" {
  description = "Linode API token"
  type        = string
}

variable "linode_region" {
  description = "Region to place instances; see https://api.linode.com/v4/regions"
  type        = string
  default     = "us-central"
}

variable "linode_image" {
  description = "Base image ID for instance boot disks; see https://www.linode.com/docs/api/images"
  type        = string
  default     = "linode/ubuntu22.04"
}

variable "linode_type" {
  description = "Instance type; see https://api.linode.com/v4/linode/types"
  type        = string
  default     = "g6-standard-2"
}
