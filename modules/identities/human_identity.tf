resource "vault_identity_entity" "aaron" {
  name     = "aaron"
  policies = ["user-aaron-access"]
  metadata = {
    user = "aaron"
    team = "blue"
  }
}

resource "vault_identity_entity_alias" "aaron_ldap_alias" {
  name           = "aaron"
  mount_accessor = var.ldap_accessor
  canonical_id   = vault_identity_entity.aaron.id
}

resource "vault_identity_entity_alias" "aaron_oidc_alias" {
  name           = ""
  mount_accessor = var.oidc_accessor
  canonical_id   = vault_identity_entity.aaron.id
  
}

resource "vault_identity_entity" "simon" {
  name     = "simon"
  policies = []
  metadata = {
    user = "simon"
    team = "blue"
  }
}

resource "vault_identity_entity_alias" "simon_ldap_alias" {
  name           = "simon"
  mount_accessor = var.ldap_accessor
  canonical_id   = vault_identity_entity.simon.id
}

resource "vault_identity_entity_alias" "simon_oidc_alias" {
  name           = ""
  mount_accessor = var.oidc_accessor
  canonical_id   = vault_identity_entity.simon.id
}