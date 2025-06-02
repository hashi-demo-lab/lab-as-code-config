variable "manifest_directory" {
  description = "Path to the directory containing Kubernetes manifest files"
  type        = string
  default     = "./manifests"
}

variable "enable_manifests" {
  description = "Map of manifest file names to boolean indicating whether they should be deployed"
  type        = map(bool)
  default     = {}
}

variable "kubernetes_manifests_enabled" {
  description = "Enable or disable applying Kubernetes manifests"
  type        = bool
  default     = true
}