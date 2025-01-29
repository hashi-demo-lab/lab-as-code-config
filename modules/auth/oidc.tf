resource "vault_jwt_auth_backend" "oidc" {
  path               = "oidc" 
  type               = "oidc"
  oidc_discovery_url = "https://gitlab.com"
  oidc_client_id     = var.oidc_client_id
  oidc_client_secret = var.oidc_client_secret
  default_role       = "sea-role"
}

resource "vault_jwt_auth_backend_role" "sea-role" {
  backend        = vault_jwt_auth_backend.oidc.path
  role_name      = "sea-role"
  token_policies = ["access-aaron-namespace-secrets"]

  allowed_redirect_uris = [
    "http://localhost:8250/oidc/callback",
    "https://vault-dc1.hashibank.com/ui/vault/auth/oidc/oidc/callback"
  ]

  user_claim = "email"
  groups_claim       = "groups" # Use the `groups` claim for mapping group memberships
  claim_mappings = {
    "email" = "email"
    "name"  = "name"
  }

  bound_claims_type = "glob" # Apply glob matching for claim values
  # bound_claims = {
  #   "groups_direct" = join(", ", ["hashi-demo1", "sea7861027"])
  # }
  
}

resource "vault_identity_group" "sea_gitlab_group" {
  name     = "gitlab-sea-group"
  type     = "external"
  policies = ["user-aaron-privileged-access"] # Policies to assign for SEA GitLab group members
  metadata = {
    "namespace" = "aaron-namespace"
  }
}

resource "vault_identity_group_alias" "sea_gitlab_group_alias" {
  name           = "sea7861027" # Name of the GitLab group
  mount_accessor = vault_jwt_auth_backend.oidc.accessor
  canonical_id   = vault_identity_group.sea_gitlab_group.id
}

resource "vault_namespace" "example_namespace" {
  path = "aaron-namespace"
}

resource "vault_mount" "example_kv_engine" {
  path        = "kv"
  type        = "kv"
  options     = { version = "2" }
  description = "KV secret engine for aaron namespace"

  namespace = vault_namespace.example_namespace.path
}

resource "vault_kv_secret_v2" "example_secret" {
  mount = vault_mount.example_kv_engine.path
  name = "secrets"
  namespace = vault_namespace.example_namespace.path
  data_json = jsonencode({
    username = "example-user"
    password = "example-password"
  })
}

resource "vault_policy" "example_policy" {
  name = "access-aaron-namespace-secrets"

  policy = <<EOT
  path "{{identity.groups.names.${vault_identity_group.sea_gitlab_group.name}.metadata.namespace}}/kv/data/secrets" {
    capabilities = ["read", "list"]
  }
  EOT
}