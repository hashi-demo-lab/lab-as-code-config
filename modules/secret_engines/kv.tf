# Create a KV secrets engine
resource "vault_mount" "kv_secrets" {
  path        = var.kv_mount_path
  type        = "kv"
  options     = { version = "2" }
  description = "Key/Value secrets engine for Workload Identity demo"
}

# Placeholder for empty secret in KV engine
resource "vault_kv_secret_v2" "empty_secret" {
  mount     = vault_mount.kv_secrets.path
  name      = "empty_secret"
  data_json = jsonencode({})
}

# Team secrets configuration
resource "vault_kv_secret_v2" "team_secrets" {
  mount = vault_mount.kv_secrets.path
  name  = var.team_secrets_path
  data_json = jsonencode({
    team          = "Solution Engineers and Architects",
    location      = "Australia and New Zealand",
    football_team = "Sydney Swans"
  })
  custom_metadata {
    max_versions = 5
    data = {
      demo = "true"
    }
  }
}

# Simon's secrets
resource "vault_kv_secret_v2" "simons_secrets" {
  mount = vault_mount.kv_secrets.path
  name  = var.simons_secrets_path
  data_json = jsonencode({
    role          = "Sr Solutions Architecture Specialist",
    location      = "Sydney",
    football_team = "Cronulla Sharks"
  })
}

# Aaron's secrets
resource "vault_kv_secret_v2" "aarons_secrets" {
  mount = vault_mount.kv_secrets.path
  name  = var.aarons_secrets_path
  data_json = jsonencode({
    role          = "Solutions Engineer",
    location      = "Kiama",
    football_team = "Canterbury-Bankstown Bulldogs"
  })
}

# Development environment secrets
resource "vault_kv_secret_v2" "development_env_secrets" {
  mount = vault_mount.kv_secrets.path
  name  = "envs/development/secrets"
  data_json = jsonencode({
    environment = "development",
    db_username = "dev_user",
    db_password = "dev_pass",
    api_key     = "dev_api_key"
  })
  custom_metadata {
    data = {
      environment = "development"
      owner       = "dev_team"
    }
  }
}