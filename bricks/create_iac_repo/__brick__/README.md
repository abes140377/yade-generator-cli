# {{organization}} {{applicationName}} {{environment}}

The Repository supports the following stages:

- sbox
- labor
- prod

[![License: MIT][license_badge]][license_link]

The {{applicationName}} iac repository built with yade

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT

## Tasks

task: Available tasks for this project:

- default: Print some usefull information
- core:setup: Top Level Task to Setup Core
- {{applicationName}}:install:labor: Top Level Task to Install {{applicationName.pascalCase()}} Labor
- {{applicationName}}:install:prod: Top Level Task to Install {{applicationName.pascalCase()}} Production
- {{applicationName}}:install:sbox: Top Level Task to Install {{applicationName.pascalCase()}} Sandbox
- {{applicationName}}:reinstall:labor: Top Level Task to Re-Install {{applicationName.pascalCase()}} Labor
- {{applicationName}}:reinstall:prod: Top Level Task to Re-Install {{applicationName.pascalCase()}} Production
- {{applicationName}}:reinstall:sbox: Top Level Task to Re-Install {{applicationName.pascalCase()}} Sandbox
- {{applicationName}}:uninstall:labor: Top Level Task to Uninstall {{applicationName.pascalCase()}} Labor
- {{applicationName}}:uninstall:prod: Top Level Task to Uninstall {{applicationName.pascalCase()}} Production
- {{applicationName}}:uninstall:sbox: Top Level Task to Uninstall {{applicationName.pascalCase()}} Sandbox

ansible tasks:

- ansible:generate:docs: Generate documentation for Ansible
- ansible:playbook:site:labor: Run Ansible Playbook for Labor
- ansible:playbook:site:prod: Run Ansible Playbook for Production
- ansible:playbook:site:sbox: Run Ansible Playbook for Sandbox
- ansible:test:labor: Test Ansible Connectivity to the Labor VM
- ansible:test:prod: Test Ansible Connectivity to the Production VM
- ansible:test:sbox: Test Ansible Connectivity to the Sandbox VM

ssh tasks:

- ssh:connect:labor: Connect to the Labor VM via SSH
- ssh:connect:prod: Connect to the Production VM via SSH
- ssh:connect:sbox: Connect to the Sandbox VM via SSH
- ssh:test:labor: Test SSH Connectivity to the Labor VM
- ssh:test:prod: Test SSH Connectivity to the Production VM
- ssh:test:sbox: Test SSH Connectivity to the Sandbox VM

terraform tasks:

- terraform:apply:labor: Apply Terraform for Labor
- terraform:apply:prod: Apply Terraform for Production
- terraform:apply:sbox: Apply Terraform for Sandbox
- terraform:destroy:labor: Destroy Terraform for Labor
- terraform:destroy:prod: Destroy Terraform for Production
- terraform:destroy:sbox: Destroy Terraform for Sandbox
- terraform:generate:docs:labor: Generate Terraform Labor Documentation
- terraform:generate:docs:prod: Generate Terraform Production Documentation
- terraform:generate:docs:sbox: Generate Terraform Sandbox Documentation
- terraform:init:labor: Initialize Terraform for Labor
- terraform:init:prod: Initialize Terraform for Production
- terraform:init:sbox: Initialize Terraform for Sandbox
- terraform:output:labor: Output Terraform for Labor
- terraform:output:prod: Output Terraform for Production
- terraform:output:sbox: Output Terraform for Sandbox
- terraform:plan:labor: Plan Terraform for Labor
- terraform:plan:prod: Plan Terraform for Production
- terraform:plan:sbox: Plan Terraform for Sandbox
- vault:get:private_key:labor: Read private key for the Labor VM from vault and store it in the playbook directory to be used by ansible
- vault:get:private_key:prod: Read private key for the Production VM from vault and store it in the playbook directory to be used by ansible
- vault:get:private_key:sbox: Read private key for the Sandbox VM from vault and store it in the playbook directory to be used by ansible
- yade:setup: Install additional Software to YADE software directory at /home/itag001202/projects/cas-yade/software

internal tasks:

- \_ssh:connect: Connect to a VM via SSH
- \_ssh:test: Test SSH Connectivity to a VM
- \_vault:get:private_key: Read private key for a VM from vault and store it in the playbook directory to be used by ansible
