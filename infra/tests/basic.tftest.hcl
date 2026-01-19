# Provider "cloudflare/cloudflare" docs:
# https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs
provider "cloudflare" {
  api_token = local.cloudflare_token
}

# Provider "carlpett/sops" docs:
# https://registry.terraform.io/providers/carlpett/sops/latest/docs
provider "sops" {}

# Test the root module.
run "test_root_module" {
  command = plan
}
