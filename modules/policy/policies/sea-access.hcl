# Policy for SEA team to access shared team secrets, with control group for approval
path "demo-kv/data/teams/sea/*" {
  capabilities = ["read", "list" ]

}

path "demo-kv/data/teams/sea/*" {
  capabilities = ["create", "read", "update", "delete", "list"]

  control_group = {
    factor "admin_approval" {
      identity {
        group_names = ["ldap-administrators-group"]
        approvals = 1
      }
    }
  }
}

# Allow SEA team to list metadata for their shared secrets
path "demo-kv/metadata/teams/sea/*" {
  capabilities = ["list"]
}