# Policy for Aaron to access only Aaron's secrets
path "demo-kv/data/users/aaron/*" {
  capabilities = ["read", "list"]
  subscribe_event_types = ["*"]

   control_group = {
    factor "admin_approval" {
      identity {
        group_names = ["ldap-administrators-group"]
        approvals = 1
      }
    }
  }
}

# Allow Aaron to list metadata for his secrets
path "demo-kv/metadata/users/aaron/*" {
  capabilities = ["list"]]
  
}
