resource "kubernetes_cluster_role_binding_v1" "oidc_discovery_anonymous" {
  metadata {
    name = "oidc-discovery-anonymous"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "system:service-account-issuer-discovery"
  }

  subject {
    kind      = "Group"
    name      = "system:unauthenticated"
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "vault_jwt_auth_backend" "jwt" {
  depends_on         = [kubernetes_cluster_role_binding_v1.oidc_discovery_anonymous]
  description        = "Kubernetes JWT Auth Backend"
  path               = "jwt"
  oidc_discovery_url      = "https://kubernetes.default.svc.cluster.local"
  bound_issuer            = "https://kubernetes.default.svc.cluster.local"
  oidc_discovery_ca_pem   = local.docker_desktop_ca_cert
  # oidc_discovery_ca_pem = base64decode(
  #   yamldecode(file("~/.kube/config"))["clusters"][0]["cluster"]["certificate-authority-data"]
  # )
  

  tune {
    default_lease_ttl = "1m"
    max_lease_ttl     = "1h"
    token_type        = "default-service"
  }
}

resource "vault_jwt_auth_backend_role" "app1_role" {
  backend                 = vault_jwt_auth_backend.jwt.path
  role_name               = "app1"
  role_type               = "jwt"
  bound_audiences         = ["https://kubernetes.default.svc.cluster.local"]
  user_claim              = "/kubernetes.io/serviceaccount/name"
  user_claim_json_pointer = true
  token_policies          = ["access-all"]

  # Allows wildcards or regex in bound_claims
  bound_claims_type = "glob"

  bound_claims = {
    # Match any service account starting with "app1-service-"
    "/kubernetes.io/serviceaccount/name" = "app1-service-*"
    # Restrict to the "app1" namespace
    "/kubernetes.io/namespace" = "app1"
  }
}

resource "vault_jwt_auth_backend_role" "app2_role" {
  backend                 = vault_jwt_auth_backend.jwt.path
  role_name               = "app2"
  role_type               = "jwt"
  bound_audiences         = ["https://kubernetes.default.svc.cluster.local"]
  user_claim              = "/kubernetes.io/namespace"
  user_claim_json_pointer = true
  token_policies          = ["access-all"]
  # Allows wildcards or regex in bound_claims
  bound_claims_type = "glob"

  bound_claims = {
    "/kubernetes.io/serviceaccount/name" : "app2-service-*",
    "/kubernetes.io/namespace" : "app2"
  }
}

resource "vault_jwt_auth_backend_role" "app3_role" {
  backend         = vault_jwt_auth_backend.jwt.path
  role_name       = "app3"
  role_type       = "jwt"
  bound_audiences = ["https://kubernetes.default.svc.cluster.local"]

  # Use the nested service account name as the user claim
  user_claim              = "/kubernetes.io/serviceaccount/name"
  user_claim_json_pointer = true
  token_policies          = ["access-all"]

  # Enables wildcard matching for claims
  bound_claims_type = "glob"

  bound_claims = {
    # The SA name must be exactly 'app3-service'
    "/kubernetes.io/serviceaccount/name" = "app3-service"

    # The namespace must match 'app3-*' (e.g. app3-frontend or app3-backend)
    "/kubernetes.io/namespace" = "app3-*"
  }
}

resource "vault_jwt_auth_backend_role" "app4_web_role" {
  backend                 = vault_jwt_auth_backend.jwt.path
  role_name               = "app4-web"
  role_type               = "jwt"
  bound_audiences         = ["https://kubernetes.default.svc.cluster.local"]
  user_claim              = "/kubernetes.io/namespace"
  user_claim_json_pointer = true
  token_policies          = ["access-all"]
  bound_claims_type       = "glob"
  bound_claims = {
    "/kubernetes.io/serviceaccount/name" : "app4-web-service-*",
    "/kubernetes.io/namespace" : "app4-web"
  }
}

resource "vault_jwt_auth_backend_role" "app4_api_role" {
  backend                 = vault_jwt_auth_backend.jwt.path
  role_name               = "app4-api"
  role_type               = "jwt"
  bound_audiences         = ["https://kubernetes.default.svc.cluster.local"]
  user_claim              = "/kubernetes.io/namespace"
  user_claim_json_pointer = true
  token_policies          = ["access-all"]
  bound_claims_type       = "glob"
  bound_claims = {
    "/kubernetes.io/serviceaccount/name" : "app4-api-service-*",
    "/kubernetes.io/namespace" : "app4-api"
  }
}

resource "vault_jwt_auth_backend_role" "app4_db_role" {
  backend                 = vault_jwt_auth_backend.jwt.path
  role_name               = "app4-db"
  role_type               = "jwt"
  bound_audiences         = ["https://kubernetes.default.svc.cluster.local"]
  user_claim              = "/kubernetes.io/namespace"
  user_claim_json_pointer = true
  token_policies          = ["access-all"]
  bound_claims_type       = "glob"
  bound_claims = {
    "/kubernetes.io/serviceaccount/name" : "app4-db-service-*",
    "/kubernetes.io/namespace" : "app4-db"
  }
}

resource "vault_jwt_auth_backend" "tfc" {
  description        = "JWT Backend for Terraform Cloud"
  path               = "tfc"
  type               = "jwt"
  oidc_discovery_url = "https://app.terraform.io"
  bound_issuer       = "https://app.terraform.io"
}

resource "vault_jwt_auth_backend_role" "strategy_and_architecture_np" {
  backend        = vault_jwt_auth_backend.tfc.path
  role_name      = "strategy_and_architecture_np"
  token_policies = ["access-all"]

  bound_audiences   = ["vault.workload.identity"]
  bound_claims_type = "glob"
  bound_claims = {
    sub = "organization:cloudbrokeraz:project:strat_arch_nonprod:workspace:*:run_phase:*"
  }

  user_claim    = "terraform_full_workspace"
  role_type     = "jwt"
  token_max_ttl = "900"
}

resource "vault_jwt_auth_backend_role" "hashi-demos-apj" {
  backend        = vault_jwt_auth_backend.tfc.path
  role_name      = "hashi-demos-apj"
  token_policies = ["access-all"]

  bound_audiences   = ["vault.workload.identity"]
  bound_claims_type = "glob"
  bound_claims = {
    sub = "organization:hashi-demos-apj:project:*:workspace:*:run_phase:*"
  }

  user_claim    = "terraform_full_workspace"
  role_type     = "jwt"
  token_max_ttl = "900"
}