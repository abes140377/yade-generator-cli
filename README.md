# CLI for Repository Generation

This repository contains a command-line tool that automates the creation of repositories for deploying infrastructure with Terraform and configuring applications with Ansible.

## Why on earth...?

- Knowing best practices is one thing, but following them is another.  
  The CLI enforces best practices by generating repositories with a predefined structure and configuration.

- The CLI automates the generation of repositories, saving time and reducing the risk of human error.

- The CLI ensures that all repositories follow the same structure and configuration, making it easier to understand and work with them.

- The CLI can be extended to include additional features and integrations, further improving the development workflow.

- The CLI can be used to distribute updates to existing repositories, ensuring that they stay up to date with the latest templates and configurations.

- Writing boilerplate code is boring. Let the CLI do it for you!

## Commands

- `create-single`: Generates an empty repository for setting up a single VM using Terraform and Ansible.
- `create-cluster`: Generates an empty repository for setting up a cluster using Terraform and Ansible (currently in development).

### Templates

The repository generation is based on the following templates:
- **Template CAS VM**
- **Template Cluster**

## Purpose

The CLI's primary purpose is to automate repository creation using the CAS VM and Cluster templates. The benefits include:

- **Consistent Workflow:** All repositories follow a uniform structure and command execution process for provisioning compute resources with Terraform and configuring applications with Ansible.  
  Principle: *"If you know one, you know them all."*

- **Boilerplate Automation:** Repositories are automatically generated with all the required boilerplate code and are ready for use immediately.  
  This includes the integration of Ansible Dynamic Inventory for seamless usage without manual inventory setup.

- **Best Practice Structure:** Generates an Ansible structure based on best practices from `ansible-creator init playbook` and `ansible-creator init collection`.  
  More information about ansible-creator: [ansible-creator documentation](https://ansible.readthedocs.io/projects/creator/)

## Additional Features

- **Supports Stages:** sbox, labor, and prod.
- **Taskfile Integration:** Each repository contains a Taskfile that simplifies the execution of recurring commands.  
  More information about Taskfile: [Taskfile documentation](https://taskfile.dev/#/usage)

  Example tasks:
  - `task <application>:install:<stage>`  
    Example:  
    GitLab: `task gitlab:install:sbox`  
    Vault: `task vault:install:sbox`

  - `task <application>:uninstall:<stage>`  
    Example:  
    GitLab: `task gitlab:uninstall:sbox`  
    Vault: `task vault:uninstall:sbox`

  - `task <application>:connect:<stage>`  
    Example:  
    GitLab: `task gitlab:connect:sbox`  
    Vault: `task vault:connect:sbox`

  - and some more...

  Thanks to the Taskfile, execution always follows the same process. In some cases, separate documentation of the execution might not even be necessary. All steps are predefined in the Taskfile, effectively documenting themselves. Again, if you know how to run one, you know how to run them all by calling the appropriate Taskfile task.

- **SSH Key Integration:** Automatically downloads required SSH keys from Vault and integrates them into the Taskfile and Ansible.

- **Python Environment Initialization:** Sets up and initializes a Python pyenv environment with the required packages to run Ansible.

- **Prerequisite Validation:** A shell script (`doctor.sh`) checks for prerequisites to ensure successful CLI execution.

- **Ansible Collection Integration:** Includes the `cas.common` Ansible collection for reusable roles:
  - `docker`: Installs Docker on a VM.
  - `rootca`: Installs Root-CA certificates on a VM.

- **Secrets Management:** Supports local secrets management via a `.env.private` file, which is used in the Taskfile.

- **Linting Integration:** Configures linting rules for Terraform and Ansible using `pre-commit`, following best practices from the tool maintainers.  
  More information about pre-commit: [pre-commit documentation](https://pre-commit.com/)

- **Distribute Updates to Existing Repositories**: The CLI can be re-run on already created repositories to propagate updates. This allows for centralized management of changes, ensuring that existing repositories stay up to date with the latest templates and configurations.

## Getting Started

To use the CLI tool for automating repository generation, follow the steps below.

### CLI Commands

Below are the available commands for the CLI and examples of how to use them:

#### 🚀 yade create-single

This command generates a new repository for provisioning a single VM using Terraform and configuring it with Ansible.

Example:

Creates a new repository for a single VM with the following parameters:
- Organization (required): `cas` 
- Environment (required): `mgm`
- Hostname (required): `viicasmgm003`
- Ansible Collections (optional): `community.general:9.4.0,community.hashi_vault:6.2.0`
- Ansible Roles (optional): `geerlingguy.docker:7.4.1`
- Repository / Application Name (required): `example`

```bash
yade create-single \
    --organization=cas \
    --environment=mgm \
    --hostname=viicasmgm003 \
    --ansible_collections=community.general:9.4.0,community.hashi_vault:6.2.0 \
    --ansible_roles=geerlingguy.docker:7.4.1, \
    example
```

DEMO ONLY:
```bash	
task yade:create:example:single
```

#### 🚀 yade create-cluster

TODO

## Future Steps

- **Team decision:** Decide if we want to use the CLI for repository generation for our daily work with Single VM's And Clusters.
- **Yade CLI Installation in casdev:** Make the Yade CLI available to developers for usage.
- **Migration of Existing Repositories:** If desired, old repositories can be migrated to the new structure, with assistance from me.
- **Documentation:** Provide (more) detailed documentation on how to use the CLI and the generated repositories.

## Future Features

- **Generate Gitlab CI:** Automatically generate Gitlab CI pipelines for the repositories to streamline the execution in Gitlab CI
- **Integrate Terraform State Management with Gitlab** to store the Terraform state in Gitlab for better collaboration and versioning.
- **All the other things:** There are many more features that can be added to the CLI to further automate the repository generation process. Suggestions are welcome.
 
## Example Repository

The example Repository can be found [here](https://viicasapp003t.intinf.dvvbw.net/itag001202/cas-example-mgm)