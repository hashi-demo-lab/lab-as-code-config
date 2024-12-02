resource "vault_ldap_auth_backend" "ldap" {
  path           = "ldap"
  url            = "ldap://ldap-service.ldap.svc.cluster.local:389"
  userdn         = "ou=users,dc=hashibank,dc=com"
  binddn         = "cn=admin,dc=hashibank,dc=com"
  bindpass       = "admin"
  groupdn        = "ou=groups,dc=hashibank,dc=com"
  token_policies = []
  token_ttl      = 600
}

# resource "vault_ldap_auth_backend_user" "user-aaron" {
#     username = "aaron"
#     policies = ["user-aaron-access"]
#     backend  = vault_ldap_auth_backend.ldap.path
# }

resource "vault_ldap_auth_backend_group" "group" {
  groupname = "sea"
  policies = ["team-sea-access"]
  backend  = vault_ldap_auth_backend.ldap.path
}

resource "vault_ldap_auth_backend_user" "user-simon" {
    username = "simon"
    policies = ["user-simon-access"]
    backend  = vault_ldap_auth_backend.ldap.path
}

# # External Vault identity group for SEA, linked to LDAP group
# resource "vault_identity_group" "ldap_sea_group" {
#   name     = "ldap-sea-group"
#   type     = "external"
#   policies = ["team-sea-access"]
# }

# # Link the "sea_ldap_group" group to the LDAP group (SEA)
# resource "vault_identity_group_alias" "ldap_sea_group_alias" {
#   name           = "sea" # LDAP group name
#   mount_accessor = vault_ldap_auth_backend.ldap.accessor
#   canonical_id   = vault_identity_group.ldap_sea_group.id
# }

# Internal Vault identity group for SEA, linked to LDAP group
resource "vault_identity_group" "ldap_administrators_group" {
  name     = "ldap-administrators-group"
  type     = "external"
  policies = ["admin-approval-access"]
}

# Link the "sea_ldap_group" group to the LDAP group (SEA)
resource "vault_identity_group_alias" "ldap_administrators_group_alias" {
  name           = "administrators" # LDAP group name
  mount_accessor = vault_ldap_auth_backend.ldap.accessor
  canonical_id   = vault_identity_group.ldap_administrators_group.id
}