module "auth" {
  source = "./modules/auth"

  oidc_client_id     = var.oidc_client_id
  oidc_client_secret = var.oidc_client_secret
}

module "secret_engines" {
  source              = "./modules/secret_engines"
  kv_mount_path       = var.kv_mount_path
  team_secrets_path   = var.team_secrets_path
  aarons_secrets_path = var.aarons_secrets_path
  simons_secrets_path = var.simons_secrets_path
}

module "policies" {
  source = "./modules/policy"
  depends_on = [ module.auth ]
}