variable "manifest_directory" {
  description = "Path to the directory containing Kubernetes manifest files"
  type        = string
  default     = "./manifests"
}

variable "root_ca_cert" {
  description = "Root CA certificate content for template substitution"
  type        = string
}

variable "vault_server_url" {
  description = "Vault server URL for template substitution"
  type        = string
  default     = "https://vault.vault.svc.cluster.local:8200"
}