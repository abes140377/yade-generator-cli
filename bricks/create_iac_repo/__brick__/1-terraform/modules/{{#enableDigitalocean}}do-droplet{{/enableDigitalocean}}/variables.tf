variable "do_token" {}
variable "ssh_fingerprint" {}

variable "image" {
  default = "ubuntu-22-04-x64"
}
variable "size" {
  default = "s-2vcpu-4gb"
}
variable "region" {
    default = "fra1"
}
