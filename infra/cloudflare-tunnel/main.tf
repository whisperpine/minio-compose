terraform {
  required_version = ">= 1.10"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.15.0"
    }
  }
}

# https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/zero_trust_tunnel_cloudflared
resource "cloudflare_zero_trust_tunnel_cloudflared" "default" {
  account_id = var.cloudflare_account_id
  name       = var.cloudflare_tunnel_name
}

# https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/data-sources/zero_trust_tunnel_cloudflared
data "cloudflare_zero_trust_tunnel_cloudflared_token" "default" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.default.id
}

# https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/record
resource "cloudflare_dns_record" "console" {
  zone_id = var.cloudflare_zone_id
  name    = "${var.dns_record_prefix_console}.${var.cloudflare_zone}"
  content = "${cloudflare_zero_trust_tunnel_cloudflared.default.id}.cfargotunnel.com"
  comment = "minio console server"
  type    = "CNAME"
  proxied = true
  ttl     = 1 # setting to 1 means automatic
}

# https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/record
resource "cloudflare_dns_record" "api" {
  zone_id = var.cloudflare_zone_id
  name    = var.dns_record_prefix_api
  content = "${cloudflare_zero_trust_tunnel_cloudflared.default.id}.cfargotunnel.com"
  comment = "minio api server"
  type    = "CNAME"
  proxied = true
  ttl     = 1 # setting to 1 means automatic
}

# https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/tunnel_config
resource "cloudflare_zero_trust_tunnel_cloudflared_config" "default" {
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.default.id
  account_id = var.cloudflare_account_id

  config = {
    ingress = [
      {
        hostname = cloudflare_dns_record.console.name
        service  = "http://nginx:80"
        path     = ".well-known/acme-challenge/"
      },
      {
        hostname = cloudflare_dns_record.console.name
        service  = "https://nginx:443"
        origin_request = {
          no_tls_verify = true
        }
      },
      {
        hostname = cloudflare_dns_record.api.name
        service  = "http://nginx:80"
        path     = ".well-known/acme-challenge/"
      },
      {
        hostname = cloudflare_dns_record.api.name
        service  = "https://nginx:443"
        origin_request = {
          no_tls_verify = true
        }
      },
      # The last ingress rule must match all URLs.
      # (i.e. it should not have a hostname or path filter)
      {
        service = "http_status:404"
      },
    ]
  }
}
