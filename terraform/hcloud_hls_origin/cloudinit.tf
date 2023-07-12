locals {
  user_data = yamlencode({
    timezone                   = "Europe/Berlin",
    package_upgrade            = true,
    package_reboot_if_required = true,
    runcmd = [
      "docker run -ti -d --name hls_origin --restart unless-stopped -p ${var.http_port}:80 -e \"SOURCE=${var.stream_source}\" -e \"CADDY_STRIP_PREFIX=${var.caddy_strip_prefix}\" -e \"AWS_SECRET_ACCESS_KEY=${var.s3_secret_key}\" -e \"AWS_ACCESS_KEY_ID=${var.s3_access_key}\" -e \"S3_ENDPOINT=${var.s3_endpoint}\" -e \"S3_BUCKET=${var.s3_bucket}\" -e \"S3_PREFIX=${var.name}\" -e \"OVERLAY=${var.name}\" ${var.docker_image}:${var.docker_tag}",
    ]
  })

  user_data_string = "#cloud-config\n${local.user_data}"
}
