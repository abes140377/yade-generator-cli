module "naming" {
    #source = "./module/naming"
    source = "git@viicasapp003t.intinf.dvvbw.net:cas/terraform/module/naming.git?ref=v1.1.0"

    # Type for the Lookup:
    # grp : lookup for VM Group deployt via Terraform
    # k8s : Lookup for Kubernetes Cluster ToDo
    type = "grp"

    # Name for Cluster or Group
    name = local.group

    # Stage to deploy to:
    # For CAS   : prod, labor, sbox
    # For Other : prod, qs, test, dev
    stage = local.stage
    
    # Function code to deploy to:
    # mgm : CAS Management Zone
    # plt : CAS Platform Zone
    # shz : CAS Customer Zone
    function = local.function
}
