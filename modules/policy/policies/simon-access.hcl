# Policy for Simon to access only Simon's secrets
path "demo-kv/data/users/simon/*" {
  capabilities = ["read", "list"]
  subscribe_event_types = ["*"]
}

# Policy for Simon to access his secrets AND team-specific secrets like SEA and Development Environment
path "demo-kv/data/users/simon/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

