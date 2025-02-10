output "intermediate_ca_cert_pem" {
  value = vault_pki_secret_backend_intermediate_set_signed.intermediate.certificate
}