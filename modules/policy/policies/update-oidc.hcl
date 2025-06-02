# Let them list all auth methods
path "sys/auth" {
  capabilities = ["list"]
}

# Let them manage the mount plugin itself
path "sys/auth/oidc/config" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Let them manage the tune settings (TTLs)
path "sys/auth/oidc/tune" {
  capabilities = ["create", "read", "update", "delete", "list"]
}