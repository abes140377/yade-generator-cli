module "cas_grp_sbox" {
  source = "git@gitlab.mgm.cas.kvnbw.net:cas/components/terraform/cas-grp-asset.git?ref=v1.0.0"

  vm_group_name = var.vm_group_name

  location       = var.location
  group_stage    = var.group_stage
  asset_function = var.asset_function

  vms = var.vms

  vault_provider_token = var.vault_provider_token
}
