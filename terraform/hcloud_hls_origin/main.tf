data "hcloud_ssh_keys" "all_keys" {}

resource "hcloud_server" "primary" {
  name        = "hls-origin-${var.name}"
  image       = "docker-ce"
  datacenter  = "fsn1-dc14"
  server_type = var.server_type

  ssh_keys = data.hcloud_ssh_keys.all_keys.ssh_keys.*.name

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }

  user_data = local.user_data_string
}
