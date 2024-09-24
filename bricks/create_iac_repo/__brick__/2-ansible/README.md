# CAS {{applicationName.pascalCase()}} Ansible Project

## Included content/ Directory Structure

The directory structure follows best practices recommended by the Ansible community. Feel free to customize this template according to your specific project requirements.

```
 2-ansible/
 |── collections/
 |   └── requirements.yml
 |   └── ansible_collections/
 |       └── cas/
 |           └── {{applicationName}}/
 |               └── README.md
 |               └── roles/run/
 |                         └── README.md
 |                         └── tasks/main.yml
 |── inventory/
 |   └── groups_vars/
 |   └── host_vars/
 |   └── hosts.yml
 |── .gitignore
 |── ansible.cfg
 |── linux_playbook.yml
 |── network_playbook.yml
 |── README.md
 |── site.yml
```

## Compatible with Ansible-lint

Tested with ansible-lint >=24.2.0 releases and the current development version of ansible-core.
