variable "oidc_client_id" {
  description = "The OIDC client ID"
  type        = string
}

variable "oidc_client_secret" {
  description = "The OIDC client secret"
  type        = string
}

variable "kv_mount_path" {
  type        = string
  description = "Path where the KV secrets engine is mounted."
  default     = "demo-kv"
}

variable "team_secrets_path" {
  type        = string
  description = "Path for storing team-specific secrets within the KV engine."
  default     = "teams/sea/secrets"
}

variable "simons_secrets_path" {
  type        = string
  description = "Path for storing Simon's personal secrets within the KV engine."
}

variable "aarons_secrets_path" {
  type        = string
  description = "Path for storing Aaron's personal secrets within the KV engine."
}

variable "users" {
  type = map(object({
    ldap_username = string
    oidc_email    = string
    policies      = list(string)
  }))
  description = "A map of users to create in Vault."
}
