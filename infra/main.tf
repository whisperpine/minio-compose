# Generates a 64-character secret for the tunnel.
# Using `random_password` means the result is treated as sensitive and, thus,
# not displayed in console output. Refer to: https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password
resource "random_password" "tunnel_secret" {
  length = 64
}

# cloudflare_tunnel resource docs:
# https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/tunnel
resource "cloudflare_tunnel" "default" {
  account_id = var.cloudflare_account_id
  name       = var.cloudflare_tunnel_name
  secret     = base64sha256(random_password.tunnel_secret.result)
}

# cloudflare_record resource docs:
# https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/record
resource "cloudflare_record" "console" {
  zone_id = var.cloudflare_zone_id
  name    = var.dns_record_prefix_console
  value   = cloudflare_tunnel.default.cname
  comment = "minio console server"
  type    = "CNAME"
  proxied = true
}

# cloudflare_record resource docs:
# https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/record
resource "cloudflare_record" "api" {
  zone_id = var.cloudflare_zone_id
  name    = var.dns_record_prefix_api
  value   = cloudflare_tunnel.default.cname
  comment = "minio api server"
  type    = "CNAME"
  proxied = true
}

# cloudflare_tunnel_config docs:
# https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/tunnel_config
resource "cloudflare_tunnel_config" "default" {
  tunnel_id  = cloudflare_tunnel.default.id
  account_id = var.cloudflare_account_id
  config {
    ingress_rule {
      hostname = cloudflare_record.console.hostname
      service  = "http://nginx:80"
      path     = ".well-known/acme-challenge/"
    }
    ingress_rule {
      hostname = cloudflare_record.console.hostname
      service  = "https://nginx:443"
      origin_request {
        no_tls_verify = true
      }
    }
    ingress_rule {
      hostname = cloudflare_record.api.hostname
      service  = "http://nginx:80"
      path     = ".well-known/acme-challenge/"
    }
    ingress_rule {
      hostname = cloudflare_record.api.hostname
      service  = "https://nginx:443"
      origin_request {
        no_tls_verify = true
      }
    }
    # The last ingress rule must match all URLs.
    # (i.e. it should not have a hostname or path filter)
    ingress_rule {
      service = "http_status:404"
    }
  }
}
