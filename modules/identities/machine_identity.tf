resource "vault_identity_entity" "hashibank_web" {
  name     = "hashibank-web"
  policies = []
  metadata = {
    type     = "machine"
    app      = "hashibank"
    function = "web"
  }
}

resource "vault_identity_entity_alias" "alias_hashibank_web" {
  name           = "hashibank/issuer-v2"
  mount_accessor = var.kubernetes_accessor
  canonical_id   = vault_identity_entity.hashibank_web.id
}

resource "vault_identity_entity" "app4_web_entity" {
  name     = "app4-web"
  policies = []
  metadata = {
    type     = "machine"
    app      = "4"
    function = "web"
  }
}

resource "vault_identity_entity_alias" "alias_app4_web" {
  name           = "app4-web" # must match the JWT claim
  mount_accessor = var.jwt_accessor
  canonical_id   = vault_identity_entity.app4_web_entity.id
}

resource "vault_identity_entity" "app4_api_entity" {
  name     = "app4-api"
  policies = []
  metadata = {
    type     = "machine"
    app      = "4"
    function = "api"
  }
}

resource "vault_identity_entity_alias" "alias_app4_api" {
  name           = "app4-api" # must match the JWT claim
  mount_accessor = var.jwt_accessor
  canonical_id   = vault_identity_entity.app4_api_entity.id
}

resource "vault_identity_entity" "app4_db_entity" {
  name     = "app4-db"
  policies = []
  metadata = {
    type     = "machine"
    app      = "4"
    function = "db"
  }
}

resource "vault_identity_entity_alias" "alias_app4_db" {
  name           = "app4-db" # must match the JWT claim
  mount_accessor = var.jwt_accessor
  canonical_id   = vault_identity_entity.app4_db_entity.id
}

resource "vault_identity_entity" "pki-drift-detection-demo" {
  name = "tfc-workspace-pki-drift-detection-demo"
  metadata = {
  }
}

resource "vault_identity_entity_alias" "alias_tfc_workspace_pki_drift_detection_demo" {
  name           = "organization:hashi-demos-apj:project:Aarons K8s Project:workspace:pki-drift-detection-demo"
  mount_accessor = var.tfc_accessor
  canonical_id   = vault_identity_entity.pki-drift-detection-demo.id
}