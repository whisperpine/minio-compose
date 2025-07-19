# sops_file data docs:
# https://registry.terraform.io/providers/carlpett/sops/latest/docs/data-sources/file
data "sops_file" "default" {
  source_file = "encrypted.${terraform.workspace}.json"
}

locals {
  cloudflare_token          = data.sops_file.default.data["cloudflare_token"]
  cloudflare_zone           = data.sops_file.default.data["cloudflare_zone"]
  cloudflare_zone_id        = data.sops_file.default.data["cloudflare_zone_id"]
  cloudflare_account_id     = data.sops_file.default.data["cloudflare_account_id"]
  cloudflare_tunnel_name    = data.sops_file.default.data["cloudflare_tunnel_name"]
  dns_record_prefix_console = data.sops_file.default.data["dns_record_prefix_console"]
  dns_record_prefix_api     = data.sops_file.default.data["dns_record_prefix_api"]
}

module "cloudflare_tunnel" {
  source                    = "./cloudflare-tunnel"
  cloudflare_zone           = local.cloudflare_zone
  cloudflare_zone_id        = local.cloudflare_zone_id
  cloudflare_account_id     = local.cloudflare_account_id
  cloudflare_tunnel_name    = local.cloudflare_tunnel_name
  dns_record_prefix_console = local.dns_record_prefix_console
  dns_record_prefix_api     = local.dns_record_prefix_api
}
