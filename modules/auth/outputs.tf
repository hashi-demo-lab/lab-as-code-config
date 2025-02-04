output "ldap_accessor" {
    value = vault_ldap_auth_backend.ldap.accessor
}

output "oidc_accessor" {
    value = vault_jwt_auth_backend.oidc.accessor
}

output "k8s_jwt_accessor" {
    value = vault_jwt_auth_backend.jwt.accessor
}