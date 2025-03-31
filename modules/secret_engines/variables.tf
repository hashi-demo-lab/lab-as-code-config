variable "kv_mount_path" {
  type        = string
  description = "Path where the KV secrets engine is mounted."
}

variable "team_secrets_path" {
  type        = string
  description = "Path for storing team-specific secrets within the KV engine."
}

variable "simons_secrets_path" {
  type        = string
  description = "Path for storing Simon's personal secrets within the KV engine."
}

variable "aarons_secrets_path" {
  type        = string
  description = "Path for storing Aaron's personal secrets within the KV engine."
}

variable "root_ca" {
  description = "The root CA certificate"
  type        = string
}

variable "root_ca_key" {
  description = "The root CA private key"
  type        = string
}