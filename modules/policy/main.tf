locals {
  policy_files = fileset("${path.module}/policies", "*.hcl")
}

resource "vault_policy" "all_policies" {
  for_each = { for file in local.policy_files : file => file }
  name     = replace(each.key, ".hcl", "")
  policy   = file("${path.module}/policies/${each.value}")
}
