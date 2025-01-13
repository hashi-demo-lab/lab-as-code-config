locals {
  #Kubernetes objects for machine identity
  role_bindings   = file("${path.root}/manifests/vault-auth-rolebindings.yaml")
  roles           = file("${path.root}/manifests/vault-auth-roles.yaml")
  serviceaccounts = file("${path.root}/manifests/vault-auth-serviceaccounts.yaml")
}