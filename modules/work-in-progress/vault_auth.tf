/*resource "vault_github_auth_backend" "github_auth" {
  depends_on = [ helm_release.vault ]
  organization = var.github_organization
}

resource "vault_auth_backend" "userpass" {
  depends_on = [ helm_release.vault ]
  type = "userpass"
}*/