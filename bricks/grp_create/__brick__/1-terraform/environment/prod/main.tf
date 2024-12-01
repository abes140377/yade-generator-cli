module "{{organization.camelCase()}}_vm_prod" {
    source = "git@gitlab.mgm.cas.kvnbw.net:cas/components/terraform/vm-group.git?ref=v0.1.1"

    group = var.group

    location = var.location
    stage    = var.stage
    function = var.function

    network  = var.network

    vms = var.vms

    vault_provider_token = var.vault_provider_token
}
