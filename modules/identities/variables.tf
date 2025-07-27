variable "aaron_oidc_alias" {
  description = "OIDC Alias for Aaron"
  type        = string
}

variable "simon_oidc_alias" {
  description = "OIDC Alias for Simon"
  type        = string
}

variable "tony_oidc_alias" {
  description = "OIDC Alias for Tony"
  type        = string
}

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
  default = ""
}

variable "userpass_accessor" {
  description = "Userpass Auth Backend Accessor"
  type        = string
}

variable "approle_accessor" {
  description = "Approle Auth Backend Accessor"
  type        = string
}

variable "cert_accessor" {
  description = "Cert Auth Backend Accessor"
  type        = string
}

variable "kubernetes_accessor" {
  description = "K8s Auth Backend Accessor"
  type        = string
}

variable "tfc_accessor" {
  description = "TFC JWT Auth Backend Accessor"
  type        = string
  default = ""
}