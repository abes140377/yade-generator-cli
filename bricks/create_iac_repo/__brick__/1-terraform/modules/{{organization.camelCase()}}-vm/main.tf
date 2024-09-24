module "cas_vm" {
    source = "git@viicasapp003t.intinf.dvvbw.net:cas/terraform/module-cas-vm.git?ref=v1.0.1"
    
    location = var.location
    stage    = var.stage
    function = var.function

    hostname         = var.hostname
    memory           = var.memory
    num_cpus         = var.num_cpus
    system_disk_size = var.system_disk_size
    template         = var.template
    network          = var.network
    folder           = var.folder

    http_proxy = var.http_proxy
    https_proxy = var.https_proxy

    additional_domains = var.additional_domains
    domain_zone = var.domain_zone
}