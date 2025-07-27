---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hashibank-v2
  namespace: hashibank
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hashibank-v2
  template:
    metadata:
      labels:
        app: hashibank-v2
    spec:
      containers:
        - name: hashibank-v2
          image: jamiewri/hashibank:0.0.3
          args:
            - -dev
          ports:
            - containerPort: 8080
          resources:
            requests:
              cpu: 100m
              memory: 128Mi
            limits:
              cpu: 200m
              memory: 256Mi
---
apiVersion: v1
kind: Service
metadata:
  name: hashibank-v2
  namespace: hashibank
spec:
  selector:
    app: hashibank-v2
  ports:
    - protocol: TCP
      port: 8080
      targetPort: 8080
  type: NodePort
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: issuer-v2
  namespace: hashibank
---
apiVersion: v1
kind: Secret
metadata:
  name: issuer-token-v2
  namespace: hashibank
  annotations:
    kubernetes.io/service-account.name: issuer-v2
type: kubernetes.io/service-account-token
---
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: vault-issuer-v2
  namespace: hashibank
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
          name: issuer-token-v2
          key: token
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: demo-hashibank-com-v2
  namespace: hashibank
spec:
  secretName: demo-hashibank-com-tls-v2
  issuerRef:
    name: vault-issuer-v2
  commonName: demov2.hashibank.com
  dnsNames:
  - demov2.hashibank.com
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: hashibank-web-v2
  namespace: hashibank
spec:
  ingressClassName: nginx
  rules:
    - host: demov2.hashibank.com
      http:
        paths:
          - pathType: Prefix
            backend:
              service:
                name: hashibank-v2
                port:
                  number: 8080
            path: /
  tls:
  - hosts:
    - demov2.hashibank.com
    secretName: demo-hashibank-com-tls-v2
