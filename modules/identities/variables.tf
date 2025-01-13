variable "ldap_accessor" {
    description = "LDAP Auth Backend Accessor"
    type = string
}

variable "oidc_accessor" {
    description = "OIDC Auth Backend Accessor"
    type = string
}

variable "k8s_jwt_accessor" {
    description = "K8s JWT Auth Backend Accessor"
    type = string
}