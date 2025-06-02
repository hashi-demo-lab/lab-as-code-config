locals {
  policy_files = fileset("${path.module}/policies", "*.hcl")
}

resource "vault_policy" "all_policies" {
  for_each = { for file in local.policy_files : file => file }
  name     = replace(each.key, ".hcl", "")
  policy   = file("${path.module}/policies/${each.value}")
}

resource "vault_egp_policy" "enforce_ttl_limits" {
  name              = "enforce-ttl-limits"
  paths             = ["sys/auth/oidc/tune"]
  enforcement_level = "hard-mandatory"
  policy            = file("${path.module}/policies/sentinel/enforce_ttl_limits.sentinel")
}