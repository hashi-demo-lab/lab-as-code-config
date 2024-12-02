# Policy for Aaron to access only Aaron's secrets
path "demo-kv/data/users/aaron/*" {
  capabilities = ["read", "list"]
}

# Allow Aaron to list metadata for his secrets
path "demo-kv/metadata/users/aaron/*" {
  capabilities = ["list"]
}
