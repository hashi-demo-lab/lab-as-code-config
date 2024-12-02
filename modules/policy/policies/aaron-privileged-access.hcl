# Policy for Aaron to access his secrets AND team-specific secrets like SEA and Development Environment
path "demo-kv/data/users/aaron/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Allow Aaron to list metadata for his secrets with additional access control
path "demo-kv/metadata/users/aaron/*" {
  capabilities = ["list"]
}

# Additional access to team-specific secrets when logging in via OIDC
path "demo-kv/data/teams/sea/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Access to a development environment for testing
path "demo-kv/data/envs/development/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
