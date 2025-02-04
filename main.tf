module "auth" {
  source = "./modules/auth"

  oidc_client_id     = var.oidc_client_id
  oidc_client_secret = var.oidc_client_secret
}

module "identities" {
  source     = "./modules/identities"
  depends_on = [module.auth]

  ldap_accessor    = module.auth.ldap_accessor
  oidc_accessor    = module.auth.oidc_accessor
  k8s_jwt_accessor = module.auth.k8s_jwt_accessor
}

module "policies" {
  source = "./modules/policy"

  depends_on = [module.auth]
}

module "secret_engines" {
  source = "./modules/secret_engines"

  kv_mount_path       = var.kv_mount_path
  team_secrets_path   = var.team_secrets_path
  aarons_secrets_path = var.aarons_secrets_path
  simons_secrets_path = var.simons_secrets_path
}

module "kubernetes_resources" {
  source             = "./modules/kubernetes"
  depends_on         = [module.auth]
  manifest_directory = "./manifests"
}
