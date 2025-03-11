output "ldap_accessor" {
  value = vault_ldap_auth_backend.ldap.accessor
}

output "oidc_accessor" {
  value = vault_jwt_auth_backend.oidc.accessor
}

output "jwt_accessor" {
  value = vault_jwt_auth_backend.jwt.accessor
}

output "cert_accessor" {
  value = vault_auth_backend.cert.accessor
}

output "userpass_accessor" {
  value = vault_auth_backend.userpass.accessor
}

output "approle_accessor" {
  value = vault_auth_backend.approle.accessor

}

output "kubernetes_accessor" {
  value = vault_auth_backend.kubernetes.accessor
}

output "tfc_accessor" {
  value = vault_jwt_auth_backend.tfc.accessor
}