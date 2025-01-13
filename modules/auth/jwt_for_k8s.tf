resource "vault_jwt_auth_backend" "k8s_jwt" {
  description        = "Kubernetes JWT Auth Backend"
  path               = "k8s_jwt"
  oidc_discovery_url = "https://kubernetes.default.svc.cluster.local"
  bound_issuer       = "https://kubernetes.default.svc.cluster.local"
  oidc_discovery_ca_pem = base64decode(
    yamldecode(file("~/.kube/config"))["clusters"][0]["cluster"]["certificate-authority-data"]
  )
}

resource "vault_jwt_auth_backend_role" "default_role" {
  backend         = vault_jwt_auth_backend.k8s_jwt.path
  role_name       = "k8s-shared-role"
  role_type       = "jwt"
  bound_audiences = ["https://kubernetes.default.svc.cluster.local"]
  user_claim      = "/kubernetes.io/serviceaccount/name"
  user_claim_json_pointer = true
  token_policies  = ["access-aaron-namespace-secrets"]

  bound_claims = {
    "/kubernetes.io/serviceaccount/name" : "vault-auth-test",
    "/kubernetes.io/namespace"          : "vault,ldap"
  }
}

