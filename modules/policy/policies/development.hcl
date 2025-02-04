# Policy for accessing the development secrets
path "demo-kv/data/envs/development/secrets" {
  capabilities = ["read", "list"]
}

# Allow listing metadata for the development secrets
path "demo-kv/metadata/envs/development/secrets" {
  capabilities = ["list"]
}
