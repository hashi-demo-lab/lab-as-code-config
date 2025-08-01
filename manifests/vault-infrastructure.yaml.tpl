---
# Vault Certificate Infrastructure
# This template creates shared certificate management resources
# that can be used by multiple applications across the cluster

apiVersion: v1
kind: ServiceAccount
metadata:
  name: vault-cert-issuer
  namespace: hashibank
---
apiVersion: v1
kind: Secret
metadata:
  name: vault-cert-issuer-token
  namespace: hashibank
  annotations:
    kubernetes.io/service-account.name: vault-cert-issuer
type: kubernetes.io/service-account-token
---
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: vault-cluster-issuer
spec:
  vault:
    server: ${vault_server}
    path: intermediate-ca/sign/dev-role 
    caBundle: ${ca_bundle}
    auth:
      kubernetes:
        mountPath: /v1/auth/kubernetes
        role: hashibank-web
        secretRef:
          name: vault-cert-issuer-token
          key: token
