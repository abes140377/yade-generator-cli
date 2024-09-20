# Example

```sh
# Create a Infrastructure as Code project to deploy a GitLab instance
$ yade create \
    --environment=mgm \
    --hostname=viicasmgm666 \
    --ansible_collections=adfinis.gitlab:1.0.1,community.general:9.4.0 \
    gitlab

# See list of available commands
groovin --help
```
