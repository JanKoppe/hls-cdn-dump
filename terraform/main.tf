#### BASE CDN SETUP ####
resource "bunny_storagezone" "primary" {
  name   = "example"
  region = "DE"
}

resource "bunny_pullzone" "primary" {
  name                                   = "example"
  storage_zone_id                        = bunny_storagezone.primary.id
  type                                   = 1 // Volume plan
  enable_tls1_1                          = false
  enable_tlsv1                           = false
  verify_origin_ssl                      = true
  enable_cache_slice                     = true // Optimize for Video
  block_post_requests                    = true
  cache_control_browser_max_age_override = 0 // disable browser-side caching

  log_forwarding_enabled                 = true
  log_forwarding_hostname                = "example.com"
  log_forwarding_port                    = 28667

  error_page_custom_code                 = "{{status_code}} - {{status_title}}"
  error_page_enable_custom_code          = true
  error_page_whitelabel                  = false

  headers {
    enable_access_control_origin_header     = true
    access_control_origin_header_extensions = "css,js,m3u8,ts,key"
  }
}

resource "bunny_hostname" "primary" {
  hostname              = "live.example.com"
  pull_zone_id          = bunny_pullzone.primary.id
  load_free_certificate = true
  force_ssl             = true
}

resource "bunny_edgerule" "no_m3u8_cache" {
  pull_zone_id          = bunny_pullzone.primary.id
  action_type           = "override_cache_time"
  action_parameter_1    = "0"
  trigger_matching_type = "any"
  trigger {
    type                  = "url"
    pattern_matching_type = "any"
    pattern_matches = [
      "*.m3u8",
    ]
  }
}

resource "bunny_edgerule" "short_jpg_cache" {
  pull_zone_id          = bunny_pullzone.primary.id
  action_type           = "override_cache_time"
  action_parameter_1    = "5"
  trigger_matching_type = "any"
  trigger {
    type                  = "url"
    pattern_matching_type = "any"
    pattern_matches = [
      "*.jpg",
    ]
  }
}

#### HLS ORIGIN SETUP ####

module "hcloud_hls_origin" {
  for_each           = local.config
  source             = "./hcloud_hls_origin"
  name               = each.key
  caddy_strip_prefix = each.value.prefix
  stream_source      = each.value.stream_source
}

resource "bunny_edgerule" "prefix_route_origin" {
  for_each              = local.config
  pull_zone_id          = bunny_pullzone.primary.id
  action_type           = "origin_url"
  action_parameter_1    = module.hcloud_hls_origin[each.key].origin_url
  trigger_matching_type = "any"
  trigger {
    type                  = "url"
    pattern_matching_type = "any"
    pattern_matches = [
      "https://live.example.com${each.value.prefix}*",
    ]
  }
}

