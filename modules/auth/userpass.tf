resource "vault_auth_backend" "userpass" {
  type = "userpass"
  path = "userpass"
}

# Create local users
resource "vault_generic_endpoint" "aaron" {
  depends_on           = [vault_auth_backend.userpass]
  path                 = "auth/userpass/users/aaron"
  ignore_absent_fields = true
  data_json            = <<EOT
{
  "policies": ["access-all"],
  "password": "changeme"
}
EOT
}