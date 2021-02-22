variable "nomad_addr" {
    description = "Address of Nomad's HTTP interface"
    type = string
}

variable "house_uids" {
    description = "UID/GIDs for some jobs on the current host"
    type = map
}

variable "images" {
    description = "Map of Docker image names and versions"
    type = map
}
