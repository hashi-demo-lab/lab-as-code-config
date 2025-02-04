variable "oidc_client_id" {
  description = "The OIDC client ID"
  type = string
}

variable "oidc_client_secret" {
  description = "The OIDC client secret"
  type = string
}

variable "kube_config_path" {
  description = "Path to the kubeconfig file"
  type        = string
  default     = "~/.kube/config"
}
