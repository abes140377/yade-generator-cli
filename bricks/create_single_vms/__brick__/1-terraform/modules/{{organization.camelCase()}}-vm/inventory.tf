resource "ansible_host" "host" {
  name   = "${var.group}_${var.function}_${var.stage}"
  groups = ["${var.group}_servers"]

  variables = {
    ansible_host = module.cas_vm[module.naming.hostnames[0]].ipv4
    ansible_port = "22022"
    ansible_user = "ansible"
    ansible_ssh_private_key_file = "../ssh/${module.naming.hostnames[0]}_ansible_ed25519"
    ansible_python_interpreter = "/usr/bin/python3"

    # example_host = "value from host!"

    # using jsonencode() here is needed to stringify
    # a list that looks like: [ element_1, element_2, ..., element_N ]
    # yaml_list = jsonencode(local.decoded_vault_yaml.a_list)
  }
}

resource "ansible_group" "group" {
  name     = "${var.group}_servers"
  # children = ["example_digitalocean"]
  variables = {
    # example_group = "value from group!"
  }
}
