# Policy for Simon to access only Simon's secrets
path "demo-kv/data/users/simon/*" {
  capabilities = ["read", "list"]
}

# Allow Simon to list metadata for his secrets
path "demo-kv/metadata/users/simon/*" {
  capabilities = ["list"]
}