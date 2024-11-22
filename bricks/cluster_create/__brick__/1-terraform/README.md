# 1 Terraform

- [Configuration](#configuration)
  - [cluster.auto.tfvars](#clusterautotfvars)
    - [mgm](#mgm)
    - [plt](#plt)
  - [node.auto.tfvars](#nodeautotfvars)
  - [vault.auto.tfvars](#vaultautotfvars)
  - [worker.auto.tfvars](#workerautotfvars)
  - [vsphere.auto.tfvars](#vsphereautotfvars)
    - [sbox](#sbox)
    - [labor/prod](#laborprod)
- [init terraform](#init-terraform)
- [create master for the first run](#create-master-for-the-first-run)
- [create worker or update infrastructure](#create-worker-or-update-infrastructure)
- [How to destroy](#how-to-destroy)

## Configuration

### cluster.auto.tfvars

The following config combinations are possible

#### mgm

```python
cluster_function = "mgm"

cluster_stage    = "sbox"
cluster_network  = "TNT_INT|ANP_INT_CAS_MGMT|EPG_INT_CAS_MGMT_SHS_SANDBOX"

cluster_stage    = "labor"
cluster_network  = "TNT_INT|ANP_INT_CAS_MGMT|EPG_INT_CAS_MGMT_SHS_T"

cluster_stage    = "prod"
cluster_network  = "TNT_INT|ANP_INT_CAS_MGMT|EPG_INT_CAS_MGMT_SHS_P"
```

#### plt

```python
cluster_function = "plt"

cluster_stage    = "sbox"
cluster_network  = "TNT_INT|ANP_INT_CAS_PLT|EPG_INT_CAS_PLT_SHS_SANDBOX"

cluster_stage    = "labor"
cluster_network  = "TNT_INT|ANP_INT_CAS_PLT|EPG_INT_CAS_PLT_SHS_T"

cluster_stage    = "prod"
cluster_network  = "TNT_INT|ANP_INT_CAS_PLT|EPG_INT_CAS_PLT_SHS_P"
```

### node.auto.tfvars

...

### vault.auto.tfvars

...

### worker.auto.tfvars

...

### vsphere.auto.tfvars

The following config combinations are possible

#### sbox

```python
vsphere_name            = "viinfvc00025t"
vsphere_datacenter      = "Intern P2-CAS DC1"
vsphere_datastore       = "k_0000_i_nfs_25_46_04_bos_t_1_01p_m"
vsphere_compute_cluster = "I25-CL46-KA-X-CAS"
```

#### labor/prod

```python
vsphere_name            = "viinfvc00004p"
vsphere_datacenter      = "Intern Workload"
vsphere_compute_cluster = "I04-CL51-SK-L-CAS"

vsphere_datastore       = "k_0000_i_nfs_04_51_04_bos_t_1_01p_m" # Karlsruhe, Test
vsphere_datastore       = "k_0000_i_nfs_04_51_04_bos_p_1_01p_m" # Karlsruhe, Prod
vsphere_datastore       = "s_0000_i_nfs_04_51_01_bos_t_1_01p_m" # Stuttgart, Test
vsphere_datastore       = "s_0000_i_nfs_04_51_01_bos_p_1_01p_m" # Stuttgart, Prod
```

## init terraform

```bash
terraform init -upgrade
```

## create master for the first run

```bash
terraform apply -target module.control_plane
```

## create worker or update infrastructure

```bash
terraform apply
```

## How to destroy

> The order is important!

```bash
terraform destroy -target module.worker
terraform destroy
```
