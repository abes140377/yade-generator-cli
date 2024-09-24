module "cas_vm_production" {
    source   = "../../modules/cas-vm"

    vsphere_name = var.vsphere_name

    location = var.location
    stage    = var.stage
    function = var.function

    hostname = var.hostname
    network  = var.network
    folder   = var.folder

    vault_provider_token = var.vault_provider_token
    additional_domains = var.additional_domains
}
