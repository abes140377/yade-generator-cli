# {{name.pascalCase()}} {{environment.pascalCase()}}

The Repository supports the following stages:

- sandbox
- labor
- production

[![License: MIT][license_badge]][license_link]

An example iac repository built with yade

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT

## Tasks

task: Available tasks for this project:
* default:                                  Print some usefull information
* core:setup:                               Top Level Task to Setup Core
* {{name}}:install:labor:                     Top Level Task to Install Gitlab Labor
* {{name}}:install:production:                Top Level Task to Install Gitlab Production
* {{name}}:install:sandbox:                   Top Level Task to Install Gitlab Sandbox
* {{name}}:reinstall:labor:                   Top Level Task to Re-Install Gitlab Labor
* {{name}}:reinstall:production:              Top Level Task to Re-Install Gitlab Production
* {{name}}:reinstall:sandbox:                 Top Level Task to Re-Install Gitlab Sandbox
* {{name}}:uninstall:labor:                   Top Level Task to Uninstall Gitlab Labor
* {{name}}:uninstall:production:              Top Level Task to Uninstall Gitlab Production
* {{name}}:uninstall:sandbox:                 Top Level Task to Uninstall Gitlab Sandbox

ansible tasks:
* ansible:generate:docs:                    Generate documentation for Ansible
* ansible:playbook:site:labor:              Run Ansible Playbook for Labor
* ansible:playbook:site:production:         Run Ansible Playbook for Production
* ansible:playbook:site:sandbox:            Run Ansible Playbook for Sandbox
* ansible:test:labor:                       Test Ansible Connectivity to the Labor VM
* ansible:test:production:                  Test Ansible Connectivity to the Production VM
* ansible:test:sandbox:                     Test Ansible Connectivity to the Sandbox VM

ssh tasks:
* ssh:connect:labor:                        Connect to the Labor VM via SSH
* ssh:connect:production:                   Connect to the Production VM via SSH
* ssh:connect:sandbox:                      Connect to the Sandbox VM via SSH
* ssh:test:labor:                           Test SSH Connectivity to the Labor VM
* ssh:test:production:                      Test SSH Connectivity to the Production VM
* ssh:test:sandbox:                         Test SSH Connectivity to the Sandbox VM

terraform tasks:
* terraform:apply:labor:                    Apply Terraform for Labor
* terraform:apply:production:               Apply Terraform for Production
* terraform:apply:sandbox:                  Apply Terraform for Sandbox
* terraform:destroy:labor:                  Destroy Terraform for Labor
* terraform:destroy:production:             Destroy Terraform for Production
* terraform:destroy:sandbox:                Destroy Terraform for Sandbox
* terraform:generate:docs:labor:            Generate Terraform Labor Documentation 
* terraform:generate:docs:production:       Generate Terraform Production Documentation
* terraform:generate:docs:sandbox:          Generate Terraform Sandbox Documentation
* terraform:init:labor:                     Initialize Terraform for Labor
* terraform:init:production:                Initialize Terraform for Production
* terraform:init:sandbox:                   Initialize Terraform for Sandbox
* terraform:output:labor:                   Output Terraform for Labor
* terraform:output:production:              Output Terraform for Production
* terraform:output:sandbox:                 Output Terraform for Sandbox
* terraform:plan:labor:                     Plan Terraform for Labor
* terraform:plan:production:                Plan Terraform for Production
* terraform:plan:sandbox:                   Plan Terraform for Sandbox
* vault:get:private_key:labor:              Read private key for the Labor VM from vault and store it in the playbook directory to be used by ansible
* vault:get:private_key:production:         Read private key for the Production VM from vault and store it in the playbook directory to be used by ansible
* vault:get:private_key:sandbox:            Read private key for the Sandbox VM from vault and store it in the playbook directory to be used by ansible
* yade:setup:                               Install additional Software to YADE software directory at /home/itag001202/projects/cas-yade/software

internal tasks:
* _ssh:connect:                             Connect to a VM via SSH
* _ssh:test:                                Test SSH Connectivity to a VM
* _vault:get:private_key:                   Read private key for a VM from vault and store it in the playbook directory to be used by ansible
