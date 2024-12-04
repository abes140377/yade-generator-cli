# CAS EXAMPLE MGM IAC repository generated with yade

The Repository supports the following stages:

- sbox
- labor
- prod

## Available Tasks

You need the task executable insalled on you system (if you like to use the tasks defined in Taskfile.yml). 

You can install it with the following command:

```bash
sudo sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin
```

For further information visit [Taskfile.dev](https://taskfile.dev/installation/)

### Help / Setup:

* default:                       Print var's
* install:deps:                  Install python and ansible dependencies

### Install:

* example:install:sbox:     Install example in the Sandbox Environment
* example:install:labor:    Install example in the Labor Environment
* example:install:prod:     Install example in the Prod Environment

### Reinstall:

* example:reinstall:sbox:   Re-Install example in the Sandbox Environment
* example:reinstall:labor:  Re-Install example in the Labor Environment
* example:reinstall:prod:   Re-Install example in the Prod Environment

### Uninstall:

* example:uninstall:sbox:   Uninstall example in the Sandbox Environment
* example:uninstall:labor:  Uninstall example in the Labor Environment
* example:uninstall:prod:   Uninstall example in the Prod Environment

### SSH Connect

* example:connect:sbox:     Connect to the Sandbox VM via SSH
* example:connect:labor:    Connect to the Labor VM via SSH
* example:connect:prod:     Connect to the Prod VM via SSH
