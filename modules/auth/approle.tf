resource "vault_auth_backend" "approle" {
  type = "approle"
  path = "approle"
}

# Create a role named, "test-role"
resource "vault_approle_auth_backend_role" "test-role" {
  depends_on     = [vault_auth_backend.approle]
  backend        = vault_auth_backend.approle.path
  role_name      = "test-role"
  token_policies = ["access-all"]
}