variable "nomad_addr" {
    description = "Address of Nomad's HTTP interface"
    type = string
}

variable "images" {
    description = "Map of Docker image names and versions"
    type = map
}
