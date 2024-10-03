resource "ansible_host" "host" {
  name   = "{{applicationName}}_{{organization}}_digitalocean"
  groups = ["{{applicationName}}_servers"]

  variables = {
    ansible_host = digitalocean_droplet.{{applicationName}}.ipv4_address
    ansible_port = "22"
    ansible_user = "root"
    ansible_ssh_private_key_file = "~/.ssh/id_rsa"
    # ansible_ssh_private_key_file = "/Users/seba/.ssh/id_rsa"

    example_host = "value from host!"
#
#     # using jsonencode() here is needed to stringify
#     # a list that looks like: [ element_1, element_2, ..., element_N ]
#     yaml_list = jsonencode(local.decoded_vault_yaml.a_list)
  }
}

resource "ansible_group" "group" {
  name     = "{{applicationName}}_servers"
  # children = ["{{applicationName}}_digitalocean"]
  variables = {
    example_group = "value from group!"
  }
}
