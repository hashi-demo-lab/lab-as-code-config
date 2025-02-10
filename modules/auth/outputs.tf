output "ldap_accessor" {
  value = vault_ldap_auth_backend.ldap.accessor
}

output "oidc_accessor" {
  value = vault_jwt_auth_backend.oidc.accessor
}

output "jwt_accessor" {
  value = vault_jwt_auth_backend.jwt.accessor
}

output "kubernetes_accessor" {
  value = vault_auth_backend.kubernetes.accessor
}

output "tfc_accessor" {
  value = vault_jwt_auth_backend.tfc.accessor
}