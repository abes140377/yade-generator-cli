module "path" {
    source = "git@viicasapp003t.intinf.dvvbw.net:cas/terraform/module/path.git?ref=v1.0.0"

    stage = local.stage
    function = local.function
    type = "group"  
}
