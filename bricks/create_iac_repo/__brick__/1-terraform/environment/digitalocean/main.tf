module "{{applicationName.camelCase()}}_do_droplet" {
  source = "../../modules/do-droplet"

  ssh_fingerprint = var.ssh_fingerprint
  do_token        = var.do_token
}
