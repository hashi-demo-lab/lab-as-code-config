pid_file = "./pidfile"

vault {
  address         = "https://vault.hashibank.com:443"
  tls_skip_verify = false
}

auto_auth {
  method {
    type = "token_file"
    config = {
      token_file_path = "/Users/aarone/.vault-token"
    }
  }
  sink "file" {
    config = {
      path = "/Users/aarone/vault-token-via-agent"
    }
  }
}

#Demo PKI Certificates
template {
  source      = "/Users/aarone/Documents/repos/lab-as-code-config/agent/pki-demo.tmpl"
  destination = "/Users/aarone/Documents/repos/lab-as-code-config/agent/secrets/pki-demo-cert.pem"
  
  # Optional: Ensure the parent directories exist
  create_dest_dirs = true

  # Exec block to copy the file with a timestamp on change
  exec {
    command = [
      "/bin/bash",
      "-c",
      "cp /Users/aarone/Documents/repos/lab-as-code-config/agent/secrets/pki-demo-cert.pem /Users/aarone/Documents/repos/lab-as-code-config/agent/secrets/pki-demo-cert-$(date +%Y%m%d%H%M%S).pem"
    ]
    timeout = "30s"
  }
}

#Demo Key-Value Secrets
# template {
#    source      = "/Users/aarone/Documents/repos/sea-vault-demos/vault-agent/kv-demo.tmpl"
#    destination = "/Users/aarone/Documents/repos/sea-vault-demos/vault-agent/secrets/kv-demo.json"
# }

#Demo Dynamic Database Credentials
/*template {
   source      = "/Users/aarone/Documents/repos/sea-vault-demos/vault-agent/dynamic-db-demo.tmpl"
   destination = "/Users/aarone/Documents/repos/sea-vault-demos/vault-agent/secrets/dynamic-db-demo.yaml"
}*/