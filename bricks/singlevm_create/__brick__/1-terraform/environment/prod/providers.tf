terraform {
  backend "local" {
    # Update path for state file
    path = "~/state/temp.tfstate"
  }

  # backend "http" {
  #   address = "https://gitlab.mgm.cas.kvnbw.net/api/v4/projects/15/terraform/state/cas-vm-prod-tfstate"
  #   lock_address = "https://gitlab.mgm.cas.kvnbw.net/api/v4/projects/15/terraform/state/cas-vm-prod-tfstate/lock"
  #   unlock_address = "https://gitlab.mgm.cas.kvnbw.net/api/v4/projects/15/terraform/state/cas-vm-prod-tfstate/lock"
  #   lock_method = "POST"
  #   unlock_method = "DELETE"
  #   retry_wait_min = 5
  #   skip_cert_verification = true
  # }
}
