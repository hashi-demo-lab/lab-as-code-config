data "local_file" "root_ca_cert" {
  filename = "${path.root}/../certificates/lab-root-ca.crt"
}

module "secret_engines" {
  source = "./modules/secret_engines"

  kv_mount_path       = var.kv_mount_path
  team_secrets_path   = var.team_secrets_path
  aarons_secrets_path = var.aarons_secrets_path
  simons_secrets_path = var.simons_secrets_path
  root_ca             = data.local_file.root_ca_cert.content
  root_ca_key         = data.local_file.root_ca_key.content
}

module "auth" {
  source = "./modules/auth"

  oidc_client_id     = var.oidc_client_id
  oidc_client_secret = var.oidc_client_secret
  root_ca    = data.local_file.root_ca_cert.content
}

module "identities" {
  source              = "./modules/identities"
  ldap_accessor       = module.auth.ldap_accessor
  oidc_accessor       = module.auth.oidc_accessor
  jwt_accessor        = module.auth.jwt_accessor
  userpass_accessor   = module.auth.userpass_accessor
  approle_accessor    = module.auth.approle_accessor
  kubernetes_accessor = module.auth.kubernetes_accessor
  tfc_accessor        = module.auth.tfc_accessor
  cert_accessor       = module.auth.cert_accessor

  depends_on = [module.auth]
}

module "policies" {
  source = "./modules/policy"

  depends_on = [module.auth]
}

module "kubernetes_resources" {
  source             = "./modules/kubernetes"
  depends_on         = [module.auth]
  manifest_directory = "./manifests"
}