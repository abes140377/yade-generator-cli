locals {
  group = var.group
  stage = var.stage
  function = var.function
  location = var.location
  network  = var.network
  template = var.template
  folder = "${module.path.vsphere_folder}/${local.group}"

  http_proxy = var.http_proxy
  https_proxy = var.https_proxy

  vms = { for vm in var.vms : module.naming.hostnames[index(var.vms,vm)] => {
      location = local.location
      template = local.template
      network = local.network
      num_cpus = vm.num_cpus
      memory = vm.memory
      system_disk_size = vm.system_disk_size
      additional_domains = []
  }}
}

locals {
  vault = {
    path_vsphere = "${var.vault_api_credential_base_path}/vsphere/${module.vsphere.vsphere_name}"
    path_dns     = "${var.vault_api_credential_base_path}/dns"
  }
}
