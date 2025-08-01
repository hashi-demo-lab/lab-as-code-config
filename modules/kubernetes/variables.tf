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

variable "nextjs_image" {
  description = "Docker image for Next.js application"
  type        = string
  default     = "hashibank-nextjs"
}

variable "nextjs_tag" {
  description = "Docker image tag for Next.js application"
  type        = string
  default     = "latest"
}

variable "app_domain" {
  description = "Domain name for the application"
  type        = string
  default     = "caddy.hashibank.com"
}

variable "cert_issuer" {
  description = "Certificate issuer for TLS certificates"
  type        = string
  default     = "vault-issuer"
}

variable "app_domain_secret" {
  description = "Secret name for domain TLS certificate"
  type        = string
  default     = "caddy-hashibank-tls"
}