# ========================
# Stage specific variables
# ========================

variable "location" {
  description = "The location of the datacenter to deploy to: Karlsruhe or Stuttgart"
  type        = string
  default     = "Karlsruhe"
}

variable "stage" {
  description = "The stage to deploy to: sbox, labor, prod"
  type        = string
  default     = "sbox"
}

variable "function" {
  description = "The function for the deployment: mgm, plt, shz"
  type        = string
  default     = "mgm"
}

variable "hostname" {
  description = "Hostname of the vm to create"
  type        = string
}

variable "additional_domains" {
    description = "Additional Domains to set for the vm"
    type        = list(string)
    default     = [ "gitlab-mgm.sbox" ]
}

variable "network" {
  description = "The network to get the ip for the vm"
  type        = string
  default     = "TNT_INT|ANP_INT_CAS_MGMT|EPG_INT_CAS_MGMT_SHS_SANDBOX"  # sandbox
}

variable "folder" {
  description = "The folder in vSphere to place the vm in"
  type        = string
  default     = "sbox"
}

variable "vsphere_name" {
    description = "The hostname of the vsphere to use"
    type        = string
    default     = "viinfvc00025t" # sandbox
}

# ==================================
# Common variables across all stages
# ==================================

variable "vault_provider_token" {
  description = "Vault access token"
  type        = string
}
