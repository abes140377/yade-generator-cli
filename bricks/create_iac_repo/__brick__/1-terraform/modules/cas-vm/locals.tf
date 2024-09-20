locals {
  vault = {
    path_vsphere = "${var.vault_api_credential_base_path}/vsphere/${var.vsphere_name}"
    path_dns     = "${var.vault_api_credential_base_path}/dns"
  }
}
