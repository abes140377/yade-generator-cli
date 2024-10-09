variable "group" {
  description = "Name for the vm group"
  type        = string
}

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

variable "network" {
    description = "The network to get the ip for the vm"
    type        = string
    validation {
        condition     = contains(["TNT_INT|ANP_INT_CAS_MGMT|EPG_INT_CAS_MGMT_SHS_SANDBOX", "TNT_INT|ANP_INT_CAS_MGMT|EPG_INT_CAS_MGMT_SHS_T", "TNT_INT|ANP_INT_CAS_MGMT|EPG_INT_CAS_MGMT_SHS_P"], var.network)
        error_message = "Valid values for var: network are (TNT_INT|ANP_INT_CAS_MGMT|EPG_INT_CAS_MGMT_SHS_SANDBOX, TNT_INT|ANP_INT_CAS_MGMT|EPG_INT_CAS_MGMT_SHS_T or TNT_INT|ANP_INT_CAS_MGMT|EPG_INT_CAS_MGMT_SHS_P)."
    }
}

variable "template" {
    description = "The template used to clone the vm from. Must be present on the vsphere host"
    type        = string
    default     = "ubuntu-jammy-22.04-cloudimg-20240221"
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

variable "vms" {
  description = "ToDo"
  type = list(object({
    num_cpus = number
    memory    = number
    system_disk_size = number
    
    # network
    # template
    # additional_domains = list(string)
  }))
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
