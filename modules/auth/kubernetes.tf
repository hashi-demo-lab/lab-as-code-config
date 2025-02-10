locals {
  kubeconfig = yamldecode(file(var.kube_config_path))
  cluster    = local.kubeconfig.clusters[0].cluster
}

resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
}

resource "vault_kubernetes_auth_backend_config" "kubernetes_config" {
  backend            = vault_auth_backend.kubernetes.path
  kubernetes_host    = local.cluster.server
  kubernetes_ca_cert = base64decode(local.cluster["certificate-authority-data"])
  # token_reviewer_jwt omitted as it is optional
}

resource "vault_kubernetes_auth_backend_role" "hashibank-web" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "hashibank-web"
  bound_service_account_names      = ["*"]
  bound_service_account_namespaces = ["hashibank"]
  token_ttl                        = 259200
  token_policies                   = ["request-cert"]
  alias_name_source                = "serviceaccount_name"
}

resource "vault_kubernetes_auth_backend_role" "app5" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "app5"
  bound_service_account_names      = ["*"]
  bound_service_account_namespaces = ["app5"]
  token_ttl                        = 259200
  token_policies                   = ["development"]
}