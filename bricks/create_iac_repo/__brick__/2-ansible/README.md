# {{organization.upperCase()}} {{applicationName.pascalCase()}} Ansible Project

## Included content/ Directory Structure

The directory structure follows best practices recommended by the Ansible community. Feel free to customize this template according to your specific project requirements.

```
 ansible-project/
 |── collections/
 |   └── ansible_collections/
 |       └── {{organization.camelCase()}}/
 |           └── {{applicationName.camelCase()}}/
 |               └── README.md
 |               └── roles/install/
 |                         └── README.md
 |                         └── tasks/main.yml
 |── inventory/
 |   └── groups_vars/
 |   └── host_vars/
 |   └── hosts.yml
 |── ansible.cfg
 |── README.md
 |── site.yml
```

## Compatible with Ansible-lint

Tested with ansible-lint >=24.2.0 releases and the current development version of ansible-core.
