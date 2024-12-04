variable "cluster_stage" {
  description = "The stage of the cluster (e.g., sbox, labor, prod)."
  type        = string
  default     = "labor"
}

variable "cluster_function" {
  description = "The function of the cluster (e.g., mgm, plt, shz)."
  type        = string
  default     = "mgm"
}

variable "cluster_name" {
  description = "name of cluster for naming modules"
  type        = string
  default     = "example"
}

variable "control_plane_group" {
  description = "Configuration for the control plane group."
  type = object({
    count            = number
    num_cpus         = number
    memory           = number
    system_disk_size = number
    process          = string
    location         = string
    network          = optional(string, null)
  })
  default = {
    count            = 3
    num_cpus         = 2
    memory           = 4096
    system_disk_size = 64
    process          = "icas"
    location         = "Karlsruhe"
  }
}

variable "worker_groups" {
  description = "Configuration for the worker groups."
  type = map(object({
    count            = number
    memory           = number
    num_cpus         = number
    system_disk_size = number
    process          = string
    group_stage      = string
    location         = string
    network          = optional(string, null)
  }))
  default = {
    icas = {
      count            = 2
      memory           = 8192
      num_cpus         = 4
      system_disk_size = 128
      process          = "icas"
      group_stage      = "labor"
      location         = "Karlsruhe"
    }
  }
}

# ==================================
# Common variables across all stages
# ==================================

variable "vault_provider_token" {
  description = "Vault access token"
  type        = string
}
