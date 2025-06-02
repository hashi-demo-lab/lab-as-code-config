locals {
  kubeconfig = yamldecode(file(var.kube_config_path))
  docker_desktop_cluster = one([
    for cluster in local.kubeconfig.clusters : cluster
    if cluster.name == "docker-desktop"
  ])
  docker_desktop_server   = "https://kubernetes.default.svc.cluster.local"
  docker_desktop_ca_cert  = base64decode(local.docker_desktop_cluster.cluster["certificate-authority-data"])
}

resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
}

resource "vault_kubernetes_auth_backend_config" "kubernetes_config" {
  backend            = vault_auth_backend.kubernetes.path
  kubernetes_host    = local.docker_desktop_server
  kubernetes_ca_cert = local.docker_desktop_ca_cert
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
  audience                         = "vault"
  token_ttl                        = 259200
  token_policies                   = ["development"]
}