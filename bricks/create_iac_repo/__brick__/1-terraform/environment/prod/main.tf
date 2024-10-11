module "{{organization.camelCase()}}_vm_prod" {
    source   = "../../modules/{{organization.camelCase()}}-vm"

    group = var.group

    location = var.location
    stage    = var.stage
    function = var.function

    network  = var.network

    vms = var.vms

    vault_provider_token = var.vault_provider_token
}
