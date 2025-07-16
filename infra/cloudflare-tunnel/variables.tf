variable "cloudflare_zone" {
  description = "Zone is the domain (e.g. example.com)"
  type        = string
}

variable "cloudflare_zone_id" {
  description = "Zone ID for your domain"
  type        = string
}

variable "cloudflare_account_id" {
  description = "Account ID for your Cloudflare account"
  type        = string
  sensitive   = true
}

variable "cloudflare_tunnel_name" {
  description = "The name of cloudflare tunnel"
  type        = string
}

variable "dns_record_prefix_console" {
  description = "The dns record prefix for minio console server"
  type        = string
}

variable "dns_record_prefix_api" {
  description = "The dns record prefix for minio api server"
  type        = string
}
