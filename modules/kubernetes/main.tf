resource "kubernetes_manifest" "vault_auth_test" {
  manifest = yamldecode(var.role_bindings)
}

resource "kubernetes_manifest" "vault_auth_ldap" {
  manifest = yamldecode(var.roles)
}

resource "kubernetes_manifest" "vault_auth_db" {
  manifest = yamldecode(var.serviceaccounts)
}