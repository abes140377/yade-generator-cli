terraform {
  required_providers {
    ansible = {
      source  = "ansible/ansible"
      version = "1.3.0"
    }
    
    # to provision vsphere ressources
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "2.8.2"
    }

    # to store secrets and configurations
    vault = {
      source  = "hashicorp/vault"
      version = "4.3.0"
    }

    # to update dns entires
    dns = {
      source  = "hashicorp/dns"
      version = "3.4.1"
    }

    # ssh key for admin access
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.5"
    }

    # to render a valid cloudinit
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "2.3.4"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.6.2"
    }
  }
}

provider "vault" {
  # Configuration of Vault Provider
  address = var.vault_provider_address
  token   = var.vault_provider_token
  # Currently true, because our vault uses self signed certificates
  skip_tls_verify = true
}

# vault secret containing credentials for vsphere
# Should contain "VSPHERE_USER", "VSPHERE_PASSWORD", "VSPHERE_SERVER", "VSPHERE_ALLOW_UNVERIFIED_SSL"
data "vault_generic_secret" "vsphere" {
  path = local.vault.path_vsphere
}

# Provider configuration
provider "vsphere" {
  # Configuration of vSphere Provider
  user           = data.vault_generic_secret.vsphere.data["VSPHERE_USER"]
  password       = data.vault_generic_secret.vsphere.data["VSPHERE_PASSWORD"]
  vsphere_server = data.vault_generic_secret.vsphere.data["VSPHERE_SERVER"]
  # Currently true, because our vcenter use self signed certificates
  allow_unverified_ssl = data.vault_generic_secret.vsphere.data["VSPHERE_ALLOW_UNVERIFIED_SSL"]
}

# vault secret containing credentials for dns bind9 server
# Should contain "DNS_KEY_ALGORITHM", "DNS_KEY_NAME", "DNS_KEY_SECRET", "DNS_SERVER"
data "vault_generic_secret" "dns" {
  path = local.vault.path_dns
}

provider "dns" {
  update {
    server        = data.vault_generic_secret.dns.data["DNS_SERVER"]
    key_name      = data.vault_generic_secret.dns.data["DNS_KEY_NAME"]
    key_algorithm = data.vault_generic_secret.dns.data["DNS_KEY_ALGORITHM"]
    key_secret    = data.vault_generic_secret.dns.data["DNS_KEY_SECRET"]
  }
}

# provider "cloudinit" {}