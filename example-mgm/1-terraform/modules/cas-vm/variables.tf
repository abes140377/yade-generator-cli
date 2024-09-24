variable "location" {
    description = "The location of the datacenter to deploy to: Karlsruhe or Stuttgart"
    type        = string
    validation {
        condition     = contains(["Karlsruhe", "Stuttgart"], var.location)
        error_message = "Valid values for var: stage are (Karlsruhe or Stuttgart)."
    }
}

variable "stage" {
    description = "The stage to deploy to: sbox, labor, prod"
    type        = string
    validation {
        condition     = contains(["sbox", "labor", "prod"], var.stage)
        error_message = "Valid values for var: stage are (sbox, labor or prod)."
    }
}

variable "function" {
    description = "The function for the deployment: mgm, plt, shz"
    type        = string
    validation {
        condition     = contains(["mgm", "plt", "shz"], var.function)
        error_message = "Valid values for var: function are (mgm, plt or shz)."
    }
}

variable "hostname" {
    description = "Hostname of the vm to create"
    type        = string
}

variable "memory" {
    description = "The memory in MB assigned to the vm"
    type        = number
    default     = 8192
}

variable "num_cpus" {
    description = "The nubmer of vCPU cores assigned to the vm"
    type        = number
    default     = 4
}

variable "system_disk_size" {
    description = "(optional) Size of the system disk in GB"
    type        = number
    default     = 80
}

variable "template" {
    description = "The template used to clone the vm from. Must be present on the vsphere host"
    type        = string
    default     = "ubuntu-jammy-22.04-cloudimg-20240221"
}

variable "network" {
    description = "The network to get the ip for the vm"
    type        = string
    validation {
        condition     = contains(["TNT_INT|ANP_INT_CAS_MGMT|EPG_INT_CAS_MGMT_SHS_SANDBOX", "TNT_INT|ANP_INT_CAS_MGMT|EPG_INT_CAS_MGMT_SHS_T", "TNT_INT|ANP_INT_CAS_MGMT|EPG_INT_CAS_MGMT_SHS_P"], var.network)
        error_message = "Valid values for var: network are (TNT_INT|ANP_INT_CAS_MGMT|EPG_INT_CAS_MGMT_SHS_SANDBOX, TNT_INT|ANP_INT_CAS_MGMT|EPG_INT_CAS_MGMT_SHS_T or TNT_INT|ANP_INT_CAS_MGMT|EPG_INT_CAS_MGMT_SHS_P)."
    }
}

variable "folder" {
    description = "The folder in vSphere to place the vm in"
    type        = string
}

variable "additional_domains" {
    description = "Additional Domains to set for the vm"
    type        = list(string)
}

variable "domain_zone" {
    description = "The domain zone to set for the additional_domains"
    type        = string
    default     = "cas.kvnbw.net"
}

variable "http_proxy" {
    description = "Defines the http proxy the machine should use"
    type        = string
    default     = "http://webproxy.kvnbw.de:3128"
}

variable "https_proxy" {
    description = "Defines the https proxy the machine should use"
    type        = string
    default     = "http://webproxy.kvnbw.de:3128"
}

variable "vsphere_name" {
    description = "The hostname of the vsphere to use"
    type        = string
    validation {
        condition     = contains(["viinfvc00025t", "viinfvc00004p"], var.vsphere_name)
        error_message = "Valid values for var: vsphere_name are (viinfvc00025t (sandbox), viinfvc00004p (labor) or viinfvc00004p (prod)."
    }
}

# base path in vault to the get api credentials
variable "vault_api_credential_base_path" {
  description = "Vault Path to the secrets containing the credentials for vsphere"
  type        = string
  default     = "kv/cas/api-credentials"
}

# Variables for vSphere Provider
variable "vault_provider_address" {
  description = "Vault server address"
  type        = string
  default     = "https://10.242.78.75:8200"
}

variable "vault_provider_token" {
  description = "Vault access token"
  type        = string
}
