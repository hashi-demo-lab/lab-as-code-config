resource "vault_mount" "root" {
  path                      = "root-ca"
  type                      = "pki"
  description               = "Imported Long-lived Root CA"
  default_lease_ttl_seconds = 31536000
  max_lease_ttl_seconds     = 31536000
}

resource "vault_pki_secret_backend_config_ca" "import_root" {
  backend = vault_mount.root.path
  pem_bundle = <<-EOF
${var.root_ca_key}
${var.root_ca}
EOF
}

resource "vault_pki_secret_backend_config_cluster" "this" {
  backend  = vault_mount.root.path
  path     = "https://vault.primary-vault.svc.cluster.local:8200/v1/root-ca"
  aia_path = "https://vault.primary-vault.svc.cluster.local:8200/v1/root-ca"
}

# Configure URLs for root CA
resource "vault_pki_secret_backend_config_urls" "root" {
  backend = vault_mount.root.path
  issuing_certificates = [
    "https://vault.primary-vault.svc.cluster.local:8200/v1/root-ca/ca"
  ]
  crl_distribution_points = [
    "https://vault.primary-vault.svc.cluster.local:8200/v1/root-ca/crl"
  ]
  enable_templating = true
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

# Configure cluster URLs for intermediate CA
resource "vault_pki_secret_backend_config_cluster" "intermediate" {
  backend  = vault_mount.intermediate.path
  path     = "https://vault.primary-vault.svc.cluster.local:8200/v1/intermediate-ca"
  aia_path = "https://vault.primary-vault.svc.cluster.local:8200/v1/intermediate-ca"
}

# Configure URLs for intermediate CA
resource "vault_pki_secret_backend_config_urls" "intermediate" {
  backend = vault_mount.intermediate.path
  issuing_certificates = [
    "https://vault.primary-vault.svc.cluster.local:8200/v1/intermediate-ca/ca"
  ]
  crl_distribution_points = [
    "https://vault.primary-vault.svc.cluster.local:8200/v1/intermediate-ca/crl"
  ]
  ocsp_servers = [
    "https://vault.primary-vault.svc.cluster.local:8200/v1/intermediate-ca/ocsp"
  ]
  enable_templating = true
}

# Configure ACME for intermediate CA
resource "vault_pki_secret_backend_config_acme" "intermediate" {
  backend                  = vault_mount.intermediate.path
  enabled                  = true
  allowed_issuers          = ["*"]
  allowed_roles            = ["*"]
  allow_role_ext_key_usage = true
  default_directory_policy = "sign-verbatim"
  dns_resolver             = ""
  eab_policy               = "not-required"
}

resource "vault_pki_secret_backend_role" "base_role" {
  backend          = vault_mount.intermediate.path
  name             = "base"
  allowed_domains  = ["cloudbrokers.com.au", "hashibank.com"]
  allow_subdomains = true
  max_ttl          = 1800
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

resource "vault_mount" "pki_codesigning" {
  path        = "pki-codesign"
  type        = "pki"
  description = "PKI for Code Signing"
}

resource "vault_pki_secret_backend_intermediate_cert_request" "codesign_csr" {
  backend      = vault_mount.pki_codesigning.path
  type         = "internal"
  common_name  = "Vault Code Signing CA"
  organization = "hashi-demo-lab"
  country      = "AU"
  locality     = "Sydney"
  province     = "NSW"
}

resource "vault_pki_secret_backend_root_sign_intermediate" "codesign_signed" {
  backend     = vault_mount.intermediate.path
  csr         = vault_pki_secret_backend_intermediate_cert_request.codesign_csr.csr
  common_name = "Vault Code Signing CA"
}

resource "vault_pki_secret_backend_intermediate_set_signed" "codesign" {
  backend     = vault_mount.pki_codesigning.path
  certificate = vault_pki_secret_backend_root_sign_intermediate.codesign_signed.certificate
}

# resource "vault_pki_secret_backend_role" "codesign_role" {
#   backend          = vault_mount.pki_codesigning.path
#   name             = "github-actions-codesign"
#   allowed_domains  = ["code-signing.local"]
#   allow_subdomains = true
#   allow_any_name   = true
#   key_type         = "ec"
#   key_bits         = 521
#   ttl              = "1h"
#   max_ttl          = "24h"
#   generate_lease   = true
#   enforce_hostnames = false
#   require_cn       = true
# }