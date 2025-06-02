resource "vault_identity_entity" "aaron" {
  name     = "aaron"
  policies = ["aaron-access", "update-oidc", "enforce-max-ttl"]
  metadata = {
    user = "aaron"
    team = "blue"
  }
}

resource "vault_generic_endpoint" "aaron" {
  path                 = "auth/userpass/users/aaron"
  ignore_absent_fields = true
  data_json            = <<EOT
  {
    "password": "changeme"
  }
EOT
}

resource "vault_identity_entity_alias" "aaron_userpass_alias" {
  #count          = var.userpass_accessor != "" ? 1 : 0
  name           = "aaron"
  mount_accessor = var.userpass_accessor
  canonical_id   = vault_identity_entity.aaron.id
}

resource "vault_identity_entity_alias" "aaron_ldap_alias" {
  name           = "aaron"
  mount_accessor = var.ldap_accessor
  canonical_id   = vault_identity_entity.aaron.id
}

resource "vault_identity_entity_alias" "aaron_oidc_alias" {
  name           = var.aaron_oidc_alias
  mount_accessor = var.oidc_accessor
  canonical_id   = vault_identity_entity.aaron.id
}

# resource for aaron usingn cert_accessor
resource "vault_identity_entity_alias" "aaron_cert_alias" {
  name           = "aaron"
  mount_accessor = var.cert_accessor
  canonical_id   = vault_identity_entity.aaron.id
}

resource "vault_identity_entity" "tony" {
  name     = "tony"
  policies = []
  metadata = {
    user = "tony"
    team = "blue"
  }
}

resource "vault_identity_entity" "simon" {
  name     = "simon"
  policies = ["simon-access","access-all"]
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

resource "vault_identity_entity_alias" "simon_userpass_alias" {
  #count          = var.userpass_accessor != "" ? 1 : 0
  name           = "simon"
  mount_accessor = var.userpass_accessor
  canonical_id   = vault_identity_entity.simon.id
}

resource "vault_generic_endpoint" "simon" {
  path                 = "auth/userpass/users/simon"
  ignore_absent_fields = true
  data_json            = <<EOT
  {
    "password": "changeme"
  }
EOT
}

# resource "vault_identity_entity_alias" "simon_oidc_alias" {
#   name           = var.simon_oidc_alias
#   mount_accessor = var.oidc_accessor
#   canonical_id   = vault_identity_entity.simon.id
# }