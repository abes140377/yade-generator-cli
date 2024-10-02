module "vsphere" {
  source = "git@viicasapp003t.intinf.dvvbw.net:cas/terraform/module/vsphere-mapping.git?ref=v1.0.0"

  stage    = local.stage
  location = local.location
  function = local.function
}
