# ========================
# Stage specific variables
# ========================

variable "location" {
  description = "The location of the datacenter to deploy to: Karlsruhe or Stuttgart"
  type        = string
}

variable "stage" {
  description = "The stage to deploy to: sbox, labor, prod"
  type        = string
  default     = "sbox"
}

variable "function" {
  description = "The function for the deployment: mgm, plt, shz"
  type        = string
}

variable "hostname" {
  description = "Hostname of the vm to create"
  type        = string
}

variable "network" {
  description = "The network to get the ip for the vm"
  type        = string
  default     = "TNT_INT|ANP_INT_CAS_MGMT|EPG_INT_CAS_MGMT_SHS_T"  # labor (T stands for test)
}

variable "folder" {
  description = "The folder in vSphere to place the vm in"
  type        = string
  default     = "labor"
}

variable "vsphere_name" {
    description = "The hostname of the vsphere to use"
    type        = string
    default     = "viinfvc00004p" # labor (same as prod)
}

# ==================================
# Common variables across all stages
# ==================================

variable "vault_provider_token" {
  description = "Vault access token"
  type        = string
}
