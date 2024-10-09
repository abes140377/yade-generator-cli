# {{organization.upperCase()}} {{applicationName.upperCase()}} {{environment.upperCase()}} IAC repository generated with yade

The Repository supports the following stages:

- sbox
- labor
- prod

## Available Tasks

You need the task executable insalled on you system. You can install it with the following command:

```bash
sudo sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin
```

For further information visit [Taskfile.dev](https://taskfile.dev/installation/)

### Help / Setup:

* default:                       Print var's
* install:deps:                  Install python and ansible dependencies

### Install:

* {{applicationName}}:install:sbox:     Install {{applicationName}} in the Sandbox Environment
* {{applicationName}}:install:labor:    Install {{applicationName}} in the Labor Environment
* {{applicationName}}:install:prod:     Install {{applicationName}} in the Prod Environment

### Reinstall:

* {{applicationName}}:reinstall:sbox:   Re-Install {{applicationName}} in the Sandbox Environment
* {{applicationName}}:reinstall:labor:  Re-Install {{applicationName}} in the Labor Environment
* {{applicationName}}:reinstall:prod:   Re-Install {{applicationName}} in the Prod Environment

### Uninstall:

* {{applicationName}}:uninstall:sbox:   Uninstall {{applicationName}} in the Sandbox Environment
* {{applicationName}}:uninstall:labor:  Uninstall {{applicationName}} in the Labor Environment
* {{applicationName}}:uninstall:prod:   Uninstall {{applicationName}} in the Prod Environment

### SSH Connect

* {{applicationName}}:connect:sbox:     Connect to the Sandbox VM via SSH
* {{applicationName}}:connect:labor:    Connect to the Labor VM via SSH
* {{applicationName}}:connect:prod:     Connect to the Prod VM via SSH
