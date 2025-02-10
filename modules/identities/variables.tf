variable "ldap_accessor" {
  description = "LDAP Auth Backend Accessor"
  type        = string
}

variable "oidc_accessor" {
  description = "OIDC Auth Backend Accessor"
  type        = string
}

variable "jwt_accessor" {
  description = "K8s JWT Auth Backend Accessor"
  type        = string
}

variable "kubernetes_accessor" {
  description = "K8s Auth Backend Accessor"
  type        = string
}

variable "tfc_accessor" {
  description = "TFC JWT Auth Backend Accessor"
  type        = string
}