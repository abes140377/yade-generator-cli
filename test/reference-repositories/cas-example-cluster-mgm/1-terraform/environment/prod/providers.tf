terraform {
  required_version = ">= 1.9.8"

  backend "http" {
    address                = "https://gitlab.mgm.cas.kvnbw.net/api/v4/projects/19/terraform/state/cas-k8s-prod-tfstate"
    lock_address           = "https://gitlab.mgm.cas.kvnbw.net/api/v4/projects/19/terraform/state/cas-k8s-prod-tfstate/lock"
    unlock_address         = "https://gitlab.mgm.cas.kvnbw.net/api/v4/projects/19/terraform/state/cas-k8s-prod-tfstate/lock"
    lock_method            = "POST"
    unlock_method          = "DELETE"
    retry_wait_min         = 5
    skip_cert_verification = true
  }
}
