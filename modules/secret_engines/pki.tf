resource "vault_mount" "root" {
  path                      = "root-ca"
  type                      = "pki"
  description               = "Root CA"
  default_lease_ttl_seconds = 31536000
  max_lease_ttl_seconds     = 31536000
}

resource "vault_pki_secret_backend_root_cert" "root" {
  backend            = vault_mount.root.path
  type               = "internal"
  common_name        = "root-ca"
  format             = "pem"
  private_key_format = "der"
  key_type           = "rsa"
  key_bits           = 4096
  ou                 = "Solutions Engineering & Architecture "
  organization       = "hashi-demo-lab"
  country            = "AU"
  locality           = "Sydney"
  province           = "NSW"
}

resource "vault_pki_secret_backend_config_cluster" "this" {
  backend  = vault_mount.root.path
  path     = "http://127.0.0.1:8200/v1/root-ca"
  aia_path = "http://127.0.0.1:8200/v1/root-ca"
}

resource "vault_mount" "intermediate" {
  path                      = "intermediate-ca"
  type                      = "pki"
  description               = "Intermediate CA"
  default_lease_ttl_seconds = 31536000
  max_lease_ttl_seconds     = 31536000
}

resource "vault_pki_secret_backend_intermediate_cert_request" "intermediate_csr" {
  backend      = vault_mount.intermediate.path
  type         = "internal"
  common_name  = "Vault Enterprise as a Intermediate CA"
  ou           = "Vault Enterprise as a Intermediate CA"
  organization = "Vault Enterprise as a Intermediate CA"
  country      = "AU"
  locality     = "Sydney"
  province     = "NSW"
}

resource "vault_pki_secret_backend_root_sign_intermediate" "intermediate_signing" {
  backend     = vault_mount.root.path
  csr         = vault_pki_secret_backend_intermediate_cert_request.intermediate_csr.csr
  common_name = "Vault Enterprise as a Intermediate CA"
}

resource "vault_pki_secret_backend_intermediate_set_signed" "intermediate" {
  backend     = vault_mount.intermediate.path
  certificate = vault_pki_secret_backend_root_sign_intermediate.intermediate_signing.certificate
}

resource "vault_pki_secret_backend_role" "base_role" {
  backend          = vault_mount.intermediate.path
  name             = "base"
  allowed_domains  = ["cloudbrokers.com.au", "hashibank.com"]
  allow_subdomains = true
  max_ttl          = 1800
  # organization     = ["hashi-demo-lab"]
  # ou               = ["Solutions Engineering and Architecture"]
  # country          = ["Australia"]
  # locality         = ["Sydney"]
  # province         = ["NSW"]
  allow_ip_sans = false
}

resource "vault_pki_secret_backend_role" "dev_role" {
  backend          = vault_mount.intermediate.path
  name             = "dev-role"
  allowed_domains  = ["dev.example.com", "hashibank.com"]
  allow_subdomains = true
  max_ttl          = 300
}

resource "vault_pki_secret_backend_role" "test_role" {
  backend          = vault_mount.intermediate.path
  name             = "test-role"
  allowed_domains  = ["test.example.com"]
  allow_subdomains = true
  max_ttl          = 259200
}

resource "vault_pki_secret_backend_role" "prod_role" {
  backend          = vault_mount.intermediate.path
  name             = "prod-role"
  allowed_domains  = ["prod.example.com"]
  allow_subdomains = true
  max_ttl          = 259200
}