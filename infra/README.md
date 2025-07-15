# Infrastructure as Code

Setup Cloudflare Tunnel by
[Terraform](https://github.com/hashicorp/terraform)
or [OpenTofu](https://github.com/opentofu/opentofu).

## Prerequisites

- A domain hosted by Cloudflare DNS.
- An organization on Cloudflare Zero Trust.
- OpenTofu or Terraform is installed.
(Commands use `tofu` or `terraform` interchangeably hereafter).

## Get Started

Create an API Token with [proper permissions](#api-token).
Run the following commands:

```sh
cd INFRA_DIR
tofu init
tofu apply -auto-approve
```

## API Token

API Token minimal permissions:

| Permission type | Permission | Access level |
| - | - | - |
| Account | Cloudflare Tunnel | Edit |
| Account | Access: Apps and Policies | Edit |
| Zone | DNS | Edit |

## Tunnel Token

Run the following command to get tunnel token:

```sh
cd INFRA_DIR
tofu output tunnel_token
```

Tunnel Token should be assigned to `CLOUDFLARED_TOKEN` in `.env` file.
Docker will read values from `.env` file when sourcing `compose.yaml`.

## References

- [Cloudflare Terraform - Cloudflare Docs](https://developers.cloudflare.com/terraform/).
- [Deploy Tunnels with Terraform - Cloudflare Docs](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/deployment-guides/terraform/).
- [Cloudflare Provider - Terraform Registry](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs).
