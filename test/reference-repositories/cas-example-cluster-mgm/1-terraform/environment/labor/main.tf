module "cas_k8s_labor" {
  source = "git@gitlab.mgm.cas.kvnbw.net:cas/components/terraform/cas-k8s-asset.git?ref=v1.0.0"

  cluster_name = var.cluster_name

  control_plane_group = var.control_plane_group
  worker_groups       = var.worker_groups

  cluster_stage    = var.cluster_stage
  cluster_function = var.cluster_function

  vault_provider_token = var.vault_provider_token
}
