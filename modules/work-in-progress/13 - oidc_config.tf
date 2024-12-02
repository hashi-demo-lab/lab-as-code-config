/*resource "vault_jwt_auth_backend" "oidc" {
  path               = "oidc"
  type               = "oidc"
  oidc_discovery_url = "https://gitlab.com"
  oidc_client_id     = var.oidc_client_id
  oidc_client_secret = var.oidc_client_secret
  default_role       = "demo"
}

# Configure the OIDC role
resource "vault_jwt_auth_backend_role" "demo" {
  backend        = vault_jwt_auth_backend.oidc.path
  role_name      = "demo"
  token_policies = ["default"]

  allowed_redirect_uris = [
    "http://localhost:8250/oidc/callback",
    "https://vault-dc1.hashibank.com/ui/vault/auth/oidc/oidc/callback"
  ]
  user_claim = "email"
  claim_mappings = {
    "email" = "email"
    "name"  = "name"
  }
}*/