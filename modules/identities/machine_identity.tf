resource "vault_identity_entity" "app4_web_entity" {
  name     = "app4-web"
  policies = []
  metadata = {
    type = "machine"
    app  = "4"
    function = "web"
  }
}

resource "vault_identity_entity_alias" "alias_app4_web" {
  name           = "app4-web"                 # must match the JWT claim
  mount_accessor = var.k8s_jwt_accessor
  canonical_id   = vault_identity_entity.app4_web_entity.id
}

resource "vault_identity_entity" "app4_api_entity" {
  name     = "app4-api"
  policies = []
  metadata = {
    type = "machine"
    app  = "4"
    function = "api"
  }
}

resource "vault_identity_entity_alias" "alias_app4_api" {
  name           = "app4-api"                 # must match the JWT claim
  mount_accessor = var.k8s_jwt_accessor
  canonical_id   = vault_identity_entity.app4_api_entity.id
}

resource "vault_identity_entity" "app4_db_entity" {
  name     = "app4-db"
  policies = []
  metadata = {
    type = "machine"
    app  = "4"
    function = "db"
  }
}

resource "vault_identity_entity_alias" "alias_app4_db" {
  name           = "app4-db"                 # must match the JWT claim
  mount_accessor = var.k8s_jwt_accessor
  canonical_id   = vault_identity_entity.app4_db_entity.id
}