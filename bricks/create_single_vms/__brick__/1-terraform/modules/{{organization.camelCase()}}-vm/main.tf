module "{{organization}}_vm" {
    for_each = local.vms

    source = "git@viicasapp003t.intinf.dvvbw.net:cas/terraform/module-cas-vm.git?ref=v1.0.1"
    
    stage = local.stage
    function = local.function

    hostname = each.key

    location = each.value.location
    memory = each.value.memory
    num_cpus = each.value.num_cpus
    system_disk_size = each.value.system_disk_size
    template = each.value.template
    network  = each.value.network
    additional_disks = each.value.additional_disks
    additional_domains = each.value.additional_domains

    folder = local.folder

    http_proxy = local.http_proxy
    https_proxy = local.https_proxy

    additional_ssh_keys = [module.ssh.public_key_openssh]
}

output "datacenter" {
  value = module.cas_vm
}
