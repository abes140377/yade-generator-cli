# ========================
# Stage specific variables
# ========================

variable "vm_group_name" {
  description = "Name for the vm group"
  type        = string
  default     = "example"
}

variable "location" {
  description = "The location of the datacenter to deploy to: Karlsruhe or Stuttgart"
  type        = string
  default     = "Karlsruhe"
}

variable "group_stage" {
  description = "The stage to deploy to: sbox, labor, prod"
  type        = string
  default     = "prod"
}

variable "asset_function" {
  description = "The function for the deployment: mgm, plt, shz"
  type        = string
  default     = "mgm"
}

variable "vms" {
  description = "ToDo"
  type = list(object({
    num_cpus         = optional(number, 4)
    memory           = optional(number, 8196)
    system_disk_size = optional(number, 80)
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
  }))
  default = [
    {
    },
    {
    }
  ]
}

# ==================================
# Common variables across all stages
# ==================================

variable "vault_provider_token" {
  description = "Vault access token"
  type        = string
}
