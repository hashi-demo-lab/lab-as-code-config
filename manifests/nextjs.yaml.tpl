---
# Next.js Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nextjs-server
  namespace: hashibank
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nextjs-server
  template:
    metadata:
      labels:
        app: nextjs-server
    spec:
      containers:
      - name: nextjs
        image: ${nextjs_image}:${nextjs_tag}
        ports:
        - containerPort: 80
          name: http
        - containerPort: 443
          name: https
        resources:
          requests:
            cpu: 100m
            memory: 256Mi
          limits:
            cpu: 500m
            memory: 512Mi
        env:
        - name: NODE_ENV
          value: production
        - name: VAULT_ADDR
          value: "${vault_server}"
        - name: DOMAIN
          value: "${app_domain}"
        volumeMounts:
        - name: caddyfile
          mountPath: /etc/caddy/Caddyfile
          subPath: Caddyfile
        - name: ca-cert
          mountPath: /app/certs/ca.crt
          subPath: ca.crt
        - name: caddy-data
          mountPath: /data
        - name: caddy-config
          mountPath: /config
        - name: logs
          mountPath: /var/log/caddy
      volumes:
      - name: caddyfile
        configMap:
          name: nextjs-config
          items:
          - key: Caddyfile
            path: Caddyfile
      - name: ca-cert
        configMap:
          name: nextjs-config
          items:
          - key: ca.crt
            path: ca.crt
      - name: caddy-data
        emptyDir: {}
      - name: caddy-config
        emptyDir: {}
      - name: logs
        emptyDir: {}

---
# Next.js Service
apiVersion: v1
kind: Service
metadata:
  name: nextjs-service
  namespace: hashibank
spec:
  selector:
    app: nextjs-server
  ports:
  - name: http
    protocol: TCP
    port: 80
    targetPort: 80
  - name: https
    protocol: TCP
    port: 443
    targetPort: 443
  type: ClusterIP

---
# Service for caddy.hashibank.com DNS resolution inside cluster
apiVersion: v1
kind: Service
metadata:
  name: caddy-hashibank-com
  namespace: hashibank
spec:
  # No selector - we'll manually manage endpoints to point to nextjs-service
  ports:
  - name: http
    port: 80
    targetPort: 80
  - name: https
    port: 443
    targetPort: 443
  type: ClusterIP

---
# Endpoint that dynamically points to the nextjs-service ClusterIP
apiVersion: v1
kind: Endpoints
metadata:
  name: caddy-hashibank-com
  namespace: hashibank
subsets:
- addresses:
  - ip: 10.244.1.31  # nextjs pod IP - needs to be updated when pod restarts
  ports:
  - name: http
    port: 80
  - name: https
    port: 443

---
# Service for external caddy.hashibank.com DNS resolution inside cluster
apiVersion: v1
kind: Service
metadata:
  name: caddy-hashibank-external
  namespace: hashibank
spec:
  # No selector - we'll manually manage endpoints to point to nextjs pod
  ports:
  - name: http
    port: 80
    targetPort: 80
  - name: https
    port: 443
    targetPort: 443
  type: ClusterIP

---
# Endpoint for external domain pointing to nextjs pod
apiVersion: v1
kind: Endpoints
metadata:
  name: caddy-hashibank-external
  namespace: hashibank
subsets:
- addresses:
  - ip: 172.18.0.8  # nginx ingress controller LoadBalancer IP
  ports:
  - name: http
    port: 80
  - name: https
    port: 443

---
# Next.js Ingress (SSL passthrough to Caddy)
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nextjs-ingress
  namespace: hashibank
  annotations:
    nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
    nginx.ingress.kubernetes.io/ssl-passthrough: "true"
spec:
  ingressClassName: nginx
  rules:
  - host: ${app_domain}
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: nextjs-service
            port:
              number: 443

---
# ConfigMap for Caddy ACME configuration
apiVersion: v1
kind: ConfigMap
metadata:
  name: nextjs-config
  namespace: hashibank
data:
  Caddyfile: |
    {
      # Global ACME configuration - using Vault PKI ACME endpoint
      acme_ca ${vault_server}/v1/intermediate-ca/acme/directory
      acme_ca_root /app/certs/ca-decoded.crt
      email admin@hashibank.com
      skip_install_trust
    }

    # HTTP server for redirects only
    :80 {
      redir https://{host}{uri} permanent
    }

    # Primary certificate for internal service
    caddy-hashibank-com.hashibank.svc.cluster.local:443 {
      # Automatic HTTPS with Vault ACME
      tls {
        ca ${vault_server}/v1/intermediate-ca/acme/directory  
        ca_root /app/certs/ca-decoded.crt
        protocols tls1.2 tls1.3
      }
      
      # Reverse proxy to Next.js
      reverse_proxy localhost:3000

      # Logging
      log {
        output file /var/log/caddy/access.log
      }
    }

    # External domain - should work with TLS-ALPN-01 via ingress
    ${app_domain}:443 {
      # Automatic HTTPS with Vault ACME
      tls {
        ca ${vault_server}/v1/intermediate-ca/acme/directory  
        ca_root /app/certs/ca-decoded.crt
        protocols tls1.2 tls1.3
      }
      
      # Reverse proxy to Next.js
      reverse_proxy localhost:3000

      # Logging
      log {
        output file /var/log/caddy/access.log
      }
    }
  
  ca.crt: |
    ${ca_bundle}
