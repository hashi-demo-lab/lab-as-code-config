# resource "vault_identity_entity" "aaron" {
#   name     = "aaron"
#   policies = ["demo-aarons-access"]
#   metadata = {
#     user = "aaron"
#     team = "blue"
#   }
# }

# # Creating Aliases for Aaron
# resource "vault_identity_entity_alias" "aaron_ldap_alias" {
#   name           = "aaron"
#   mount_accessor = vault_ldap_auth_backend.ldap.accessor
#   canonical_id   = vault_identity_entity.aaron.id
# }

# resource "vault_identity_entity_alias" "aaron_userpass_alias" {
#   name           = "aaron"
#   mount_accessor = vault_auth_backend.userpass.accessor
#   canonical_id   = vault_identity_entity.aaron.id
# }

# resource "vault_identity_entity" "simon" {
#   name     = "simon"
#   policies = ["demo-simons-access"]
#   metadata = {
#     user = "simon"
#     team = "red"
#   }
# }

# resource "vault_identity_entity_alias" "simon_ldap_alias" {
#   name           = "simon"
#   mount_accessor = vault_ldap_auth_backend.ldap.accessor
#   canonical_id   = vault_identity_entity.simon.id
# }

# resource "vault_identity_entity" "project_vault" {
#   name     = "gitlab-project-vault"
#   policies = ["demo-aarons-access"]
#   metadata = {
#     user = "aaron"
#     team = "blue"
#   }
# }

# resource "vault_identity_entity_alias" "project_vault_alias" {
#   name           = "47452364"
#   mount_accessor = vault_jwt_auth_backend.jwt.accessor
#   canonical_id   = vault_identity_entity.project_vault.id
# }