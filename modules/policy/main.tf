resource "vault_policy" "aarons_policy" {
  name   = "user-aaron-access"
  policy = file("${path.module}/policies/aaron-access.hcl")
}

resource "vault_policy" "aarons_privileged_policy" {
  name   = "user-aaron-privileged-access"
  policy = file("${path.module}/policies/aaron-privileged-access.hcl")
}

resource "vault_policy" "simons_policy" {
  name   = "user-simon-access"
  policy = file("${path.module}/policies/simon-access.hcl")
}

resource "vault_policy" "sea_policy" {
  name   = "team-sea-access"
  policy = file("${path.module}/policies/sea-access.hcl")
}

resource "vault_policy" "admin_approval_policy" {
  name   = "admin-approval-access"
  policy = file("${path.module}/policies/admin-approval.hcl")
}