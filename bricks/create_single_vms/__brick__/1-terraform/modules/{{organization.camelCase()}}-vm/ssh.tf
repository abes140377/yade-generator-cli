# TODO Secret Engine for the Group in Vault
# TODO Folder in vSphere for the Group
module "ssh" {
  source = "git@viicasapp003t.intinf.dvvbw.net:cas/terraform/module/ssh-key.git?ref=v1.0.0"

  mount = module.path.vault_mount
  name  = "${local.group}/ssh_ansible"
}
