resource "vault_auth_backend" "cert" {
  type = "cert"
  path = "cert"
}

resource "vault_cert_auth_backend_role" "client-cert-auth" {
  backend              = vault_auth_backend.cert.path
  name                 = "client-cert-auth"
  display_name         = "Client Cert Auth Role"
  certificate          = var.root_ca
  allowed_common_names = ["aarons-macbook"]
}