# Example

```sh
# Create a Infrastructure as Code project to deploy a example application
$ yade create \
    --organization=cas \
    --environment=mgm \
    --hostname=viicasmgm666 \
    --ansible_collections=community.docker:3.12.1,community.general:9.4.0 \
    --ansible_roles=geerlingguy.docker:7.4.1 \
    example

# See list of available commands
yade --help
```
