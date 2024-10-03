# ========================
# Stage specific variables
# ========================

variable "do_token" {}
variable "ssh_fingerprint" {}

# variable "group" {
#   description = "Name for the vm group"
#   type        = string
#   default     = "{{applicationName.camelCase()}}"
# }

# variable "additional_domains" {
#     description = "Additional Domains to set for the vm"
#     type        = list(string)
#     default     = [ "{{applicationName.camelCase()}}-{{organization.camelCase()}}.sbox" ]
# }
