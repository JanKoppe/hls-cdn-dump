variable "name" {
  type = string
}

variable "server_type" {
  type    = string
  default = "ccx32"
}

variable "caddy_strip_prefix" {
  type    = string
  default = ""
}

variable "stream_source" {
  type = string
}

variable "http_port" {
  type    = number
  default = 7777
}

variable "docker_image" {
  type    = string
  default = "jankoppe/hls-origin"
}

variable "docker_tag" {
  type    = string
  default = "latest"
}

variable "s3_access_key" {
  type = string
  default = "hls-origin-vector"
}

variable "s3_secret_key" {
  type = string
  default = "CHANGEME"
}

variable "s3_bucket" {
  type = string
  default = "hls-origin-logs"
}

variable "s3_endpoint" {
  type = string
  default = "https://example.com"
}
