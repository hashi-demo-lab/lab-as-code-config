resource "vault_auth_backend" "userpass" {
  type = "userpass"
  path = "userpass"
  tune {
    default_lease_ttl = "1h"
    max_lease_ttl     = "24h"
  }
}