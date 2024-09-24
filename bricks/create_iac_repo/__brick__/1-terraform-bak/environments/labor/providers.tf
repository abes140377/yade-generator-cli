terraform {
  backend "local" {
    # Update path for state file
    path = "~/state/temp.tfstate"
  }
}
