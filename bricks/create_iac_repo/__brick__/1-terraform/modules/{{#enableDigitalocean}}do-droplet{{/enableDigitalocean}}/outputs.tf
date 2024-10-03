output "ip" {
  value = digitalocean_droplet.{{applicationName}}.ipv4_address
}
