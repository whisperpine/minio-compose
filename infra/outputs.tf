# --------------------
# module: cloudflare_tunnel
# --------------------

output "tunnel_token" {
  description = "Cloudflare Tunnel token, which should be assigned to CLOUDFLARED_TOKEN in .env"
  value       = module.cloudflare_tunnel.tunnel_token
  sensitive   = true
}
