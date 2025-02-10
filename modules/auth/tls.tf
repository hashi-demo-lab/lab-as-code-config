resource "vault_auth_backend" "cert" {
  type = "cert"
  path = "cert"
}

resource "vault_cert_auth_backend_role" "cert" {
  backend        = vault_auth_backend.cert.path
  name           = "foo"
  certificate    = var.intermediate_ca
  token_ttl      = 300
  token_max_ttl  = 600
  token_policies = ["foo"]
}