output "server_ipv4_address" {
  value = hcloud_server.primary.ipv4_address
}

output "server_ipv6_address" {
  value = hcloud_server.primary.ipv6_address
}

output "origin_url" {
  value = "http://${hcloud_server.primary.ipv4_address}:${var.http_port}"
}
