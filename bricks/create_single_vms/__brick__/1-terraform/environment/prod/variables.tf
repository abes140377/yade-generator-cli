# ========================
# Stage specific variables
# ========================

variable "group" {
  description = "Name for the vm group"
  type        = string
  default     = "{{applicationName.snakeCase()}}"
}

variable "location" {
  description = "The location of the datacenter to deploy to: Karlsruhe or Stuttgart"
  type        = string
  default     = "Karlsruhe"
}

variable "stage" {
  description = "The stage to deploy to: sbox, labor, prod"
  type        = string
  default     = "prod"
}

variable "function" {
  description = "The function for the deployment: mgm, plt, shz"
  type        = string
  default     = "mgm"
}

variable "additional_domains" {
    description = "Additional Domains to set for the vm"
    type        = list(string)
    default     = [ "{{applicationName.paramCase()}}-{{organization.paramCase()}}.sbox" ]
}

variable "network" {
  description = "The network to get the ip for the vm"
  type        = string
  default     = "TNT_INT|ANP_INT_CAS_MGMT|EPG_INT_CAS_MGMT_SHS_P"  # prod
}

variable "vms" {
  description = "ToDo"
  type = list(object({
    num_cpus = number
    memory    = number
    system_disk_size = number
    additional_disks = optional(list(object(
      {
        size       = string
        device     = string
        mount      = string
        table_type = string
        filesystem = string
      }
    )), [])
    additional_domains = optional(list(string), [])

    # network
    # template
  }))
}

variable "folder" {
  description = "The folder in vSphere to place the vm in"
  type        = string
  default     = "prod"
}

variable "vsphere_name" {
    description = "The hostname of the vsphere to use"
    type        = string
    default     = "viinfvc00004p" # prod (same as labor)
}

# ==================================
# Common variables across all stages
# ==================================

variable "vault_provider_token" {
  description = "Vault access token"
  type        = string
}
