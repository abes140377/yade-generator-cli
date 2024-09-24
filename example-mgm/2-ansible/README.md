# Cas Gitlab Ansible Project

## Included content/ Directory Structure

The directory structure follows best practices recommended by the Ansible community. Feel free to customize this template according to your specific project requirements.

```
 ansible-project/
 |── collections/
 |   └── ansible_collections/
 |       └── cas/
 |           └── gitlab/
 |               └── README.md
 |               └── roles/install/
 |                         └── README.md
 |                         └── tasks/main.yml
 |                         └── tasks/ldap-ssl-install.yml
 |── inventory/
 |   └── groups_vars/
 |   └── host_vars/
 |   └── hosts.yml
 |── ansible-navigator.yml
 |── ansible.cfg
 |── devfile.yaml
 |── linux_playbook.yml
 |── network_playbook.yml
 |── README.md
 |── site.yml
```

## Compatible with Ansible-lint

Tested with ansible-lint >=24.2.0 releases and the current development version of ansible-core.
