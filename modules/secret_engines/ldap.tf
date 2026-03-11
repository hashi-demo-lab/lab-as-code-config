# # ==============================================================================
# # LDAP Secrets Engine Configuration - Enterprise Structure
# # ==============================================================================
# # Production and Development environments with separate OUs:
# # 1. Static Credentials - Production & Development service account rotation
# # 2. Dynamic Credentials - Temporary account creation in each environment  
# # 3. Service Account Check-Out - Library accounts for shared access
# # ==============================================================================

# # Password Policy for LDAP-generated passwords
# resource "vault_password_policy" "ldap_policy" {
#   name = "ldap-password-policy"
  
#   policy = <<EOF
# length = 16
# rule "charset" {
#   charset = "abcdefghijklmnopqrstuvwxyz"
#   min-chars = 1
# }
# rule "charset" {
#   charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
#   min-chars = 1
# }
# rule "charset" {
#   charset = "0123456789"
#   min-chars = 1
# }
# rule "charset" {
#   charset = "!@#$%^&*"
#   min-chars = 1
# }
# EOF
# }

# # ==============================================================================
# # PRODUCTION ENVIRONMENT - Static Credential Management
# # ==============================================================================

# resource "vault_ldap_secret_backend" "production" {
#   path = "ldap-production"
  
#   # LDAP Connection Settings
#   binddn   = "cn=admin,dc=hashibank,dc=com"
#   bindpass = "admin"
#   url      = "ldap://ldap-service.ldap.svc.cluster.local:389"
  
#   # TLS Settings (disabled for internal demo)
#   insecure_tls = true
#   starttls     = false
  
#   # Connection Timeouts
#   connection_timeout = 30
#   request_timeout    = 90
  
#   # Production Service Accounts Search Configuration
#   userdn   = "ou=production,ou=service-accounts,dc=hashibank,dc=com"
#   userattr = "cn"

#   # Schema and Password Policy
#   schema          = "openldap"
#   password_policy = vault_password_policy.ldap_policy.name
  
#   # Production TTL settings (longer lived)
#   default_lease_ttl_seconds = 7200  # 2 hours
#   max_lease_ttl_seconds     = 86400 # 24 hours
# }

# # Production Static Roles
# resource "vault_ldap_secret_backend_static_role" "prod_svc_account1" {
#   mount     = vault_ldap_secret_backend.production.path
#   role_name = "svc-account1"
#   username  = "svc-account1"
#   dn        = "cn=svc-account1,ou=production,ou=service-accounts,dc=hashibank,dc=com"
  
#   # Daily password rotation for production
#   rotation_period = 86400
# }

# resource "vault_ldap_secret_backend_static_role" "prod_svc_account2" {
#   mount     = vault_ldap_secret_backend.production.path
#   role_name = "svc-account2"
#   username  = "svc-account2"
#   dn        = "cn=svc-account2,ou=production,ou=service-accounts,dc=hashibank,dc=com"
  
#   # Daily password rotation for production
#   rotation_period = 86400
# }

# resource "vault_ldap_secret_backend_static_role" "prod_svc_account3" {
#   mount     = vault_ldap_secret_backend.production.path
#   role_name = "svc-account3"
#   username  = "svc-account3"
#   dn        = "cn=svc-account3,ou=production,ou=service-accounts,dc=hashibank,dc=com"
  
#   # Daily password rotation for production
#   rotation_period = 86400
# }

# # ==============================================================================
# # DEVELOPMENT ENVIRONMENT - Static Credential Management
# # ==============================================================================

# resource "vault_ldap_secret_backend" "development" {
#   path = "ldap-development"
  
#   # LDAP Connection Settings
#   binddn   = "cn=admin,dc=hashibank,dc=com"
#   bindpass = "admin"
#   url      = "ldap://ldap-service.ldap.svc.cluster.local:389"
  
#   # TLS Settings (disabled for internal demo)
#   insecure_tls = true
#   starttls     = false
  
#   # Connection Timeouts
#   connection_timeout = 30
#   request_timeout    = 90
  
#   # Development Service Accounts Search Configuration
#   userdn   = "ou=development,ou=service-accounts,dc=hashibank,dc=com"
#   userattr = "cn"

#   # Schema and Password Policy
#   schema          = "openldap"
#   password_policy = vault_password_policy.ldap_policy.name
  
#   # Development TTL settings (shorter lived)
#   default_lease_ttl_seconds = 1800 # 30 minutes
#   max_lease_ttl_seconds     = 7200 # 2 hours
# }

# # Development Static Roles
# resource "vault_ldap_secret_backend_static_role" "dev_svc_account4" {
#   mount     = vault_ldap_secret_backend.development.path
#   role_name = "svc-account4"
#   username  = "svc-account4"
#   dn        = "cn=svc-account4,ou=development,ou=service-accounts,dc=hashibank,dc=com"
  
#   # More frequent rotation for development (every 4 hours)
#   rotation_period = 14400
# }

# resource "vault_ldap_secret_backend_static_role" "dev_svc_account5" {
#   mount     = vault_ldap_secret_backend.development.path
#   role_name = "svc-account5"
#   username  = "svc-account5"
#   dn        = "cn=svc-account5,ou=development,ou=service-accounts,dc=hashibank,dc=com"
  
#   # More frequent rotation for development (every 4 hours)
#   rotation_period = 14400
# }

# resource "vault_ldap_secret_backend_static_role" "dev_svc_account6" {
#   mount     = vault_ldap_secret_backend.development.path
#   role_name = "svc-account6"
#   username  = "svc-account6"
#   dn        = "cn=svc-account6,ou=development,ou=service-accounts,dc=hashibank,dc=com"
  
#   # More frequent rotation for development (every 4 hours)
#   rotation_period = 14400
# }

# # ==============================================================================
# # LIBRARY ACCOUNTS - Service Account Check-Out/Check-In
# # ==============================================================================

# resource "vault_ldap_secret_backend" "library" {
#   path = "ldap-library"
  
#   # LDAP Connection Settings
#   binddn   = "cn=admin,dc=hashibank,dc=com"
#   bindpass = "admin"
#   url      = "ldap://ldap-service.ldap.svc.cluster.local:389"
  
#   # TLS Settings (disabled for internal demo)
#   insecure_tls = true
#   starttls     = false
  
#   # Connection Timeouts
#   connection_timeout = 30
#   request_timeout    = 90
  
#   # Library Accounts Search Configuration (parent OU to search both production and development)
#   userdn   = "ou=library-accounts,dc=hashibank,dc=com"
#   userattr = "cn"

#   # Schema and Password Policy
#   schema          = "openldap"
#   password_policy = vault_password_policy.ldap_policy.name
  
#   # Library TTL settings
#   default_lease_ttl_seconds = 3600  # 1 hour
#   max_lease_ttl_seconds     = 14400 # 4 hours
# }

# # Production Library Set
# resource "vault_ldap_secret_backend_library_set" "production_library" {
#   mount = vault_ldap_secret_backend.library.path
#   name  = "production-library"
  
#   # Production library service accounts
#   service_account_names = [
#     "lib-svc-account1",
#     "lib-svc-account2",
#     "lib-svc-account3"
#   ]
  
#   # Production checkout settings (shorter checkout periods)
#   ttl     = 3600  # 1 hour checkout
#   max_ttl = 7200  # 2 hour maximum
  
#   disable_check_in_enforcement = false
# }

# # Development Library Set
# resource "vault_ldap_secret_backend_library_set" "development_library" {
#   mount = vault_ldap_secret_backend.library.path
#   name  = "development-library"
  
#   # Development library service accounts
#   service_account_names = [
#     "lib-svc-account4",
#     "lib-svc-account5", 
#     "lib-svc-account6"
#   ]
  
#   # Development checkout settings (longer checkout periods for development)
#   ttl     = 7200  # 2 hour checkout
#   max_ttl = 14400 # 4 hour maximum
  
#   disable_check_in_enforcement = false
# }

# # ==============================================================================
# # DYNAMIC CREDENTIALS - Create temporary LDAP users
# # ==============================================================================

# # Production Dynamic Role
# resource "vault_ldap_secret_backend_dynamic_role" "production_temp_users" {
#   mount     = vault_ldap_secret_backend.production.path
#   role_name = "temp-users"
  
#   # LDIF template to create temporary users in production OU
#   creation_ldif = <<EOF
# dn: cn={{.Username}},ou=production,ou=service-accounts,dc=hashibank,dc=com
# objectClass: inetOrgPerson
# objectClass: organizationalPerson
# objectClass: person
# objectClass: top
# cn: {{.Username}}
# sn: Temp Production User
# givenName: {{.Username}}
# userPassword: {{.Password}}
# description: Vault-managed temporary production user account
# EOF

#   # LDIF template to delete users when lease expires
#   deletion_ldif = <<EOF
# dn: cn={{.Username}},ou=production,ou=service-accounts,dc=hashibank,dc=com
# changetype: delete
# EOF

#   # LDIF template for rollback on creation failure
#   rollback_ldif = <<EOF
# dn: cn={{.Username}},ou=production,ou=service-accounts,dc=hashibank,dc=com
# changetype: delete
# EOF

#   # TTL settings for production temporary users (shorter lived)
#   default_ttl = 60  # 30 minutes
#   max_ttl     = 7200  # 2 hours
# }

# # Development Dynamic Role
# resource "vault_ldap_secret_backend_dynamic_role" "development_temp_users" {
#   mount     = vault_ldap_secret_backend.development.path
#   role_name = "temp-users"
  
#   # LDIF template to create temporary users in development OU
#   creation_ldif = <<EOF
# dn: cn={{.Username}},ou=development,ou=service-accounts,dc=hashibank,dc=com
# objectClass: inetOrgPerson
# objectClass: organizationalPerson
# objectClass: person
# objectClass: top
# cn: {{.Username}}
# sn: Temp Development User
# givenName: {{.Username}}
# userPassword: {{.Password}}
# description: Vault-managed temporary development user account
# EOF

#   # LDIF template to delete users when lease expires
#   deletion_ldif = <<EOF
# dn: cn={{.Username}},ou=development,ou=service-accounts,dc=hashibank,dc=com
# changetype: delete
# EOF

#   # LDIF template for rollback on creation failure
#   rollback_ldif = <<EOF
# dn: cn={{.Username}},ou=development,ou=service-accounts,dc=hashibank,dc=com
# changetype: delete
# EOF

#   # TTL settings for development temporary users (longer lived for testing)
#   default_ttl = 7200  # 2 hours
#   max_ttl     = 28800 # 8 hours
# }

# # ==============================================================================
# # DEMO OUTPUTS - Commands to demonstrate LDAP secrets engine features
# # ==============================================================================

# output "static_credential_demo_commands" {
#   description = "Commands to demonstrate static credential rotation across environments"
#   value = <<-EOT
#     # Production Static Credentials
#     vault read ldap-production/static-cred/svc-account1
#     vault read ldap-production/static-cred/svc-account2
#     vault read ldap-production/static-cred/svc-account3
    
#     # Force rotate production passwords
#     vault write -force ldap-production/rotate-role/svc-account1
#     vault write -force ldap-production/rotate-role/svc-account2
#     vault write -force ldap-production/rotate-role/svc-account3
    
#     # Development Static Credentials  
#     vault read ldap-development/static-cred/svc-account4
#     vault read ldap-development/static-cred/svc-account5
#     vault read ldap-development/static-cred/svc-account6
    
#     # Force rotate development passwords
#     vault write -force ldap-development/rotate-role/svc-account4
#     vault write -force ldap-development/rotate-role/svc-account5
#     vault write -force ldap-development/rotate-role/svc-account6
#   EOT
# }

# output "dynamic_credential_demo_commands" {
#   description = "Commands to demonstrate dynamic credential creation across environments"
#   value = <<-EOT
#     # Create temporary users in production (30min-2h TTL)
#     vault read ldap-production/creds/temp-users
#     vault read ldap-production/creds/temp-users
#     vault read ldap-production/creds/temp-users
    
#     # Create temporary users in development (2h-8h TTL)
#     vault read ldap-development/creds/temp-users
#     vault read ldap-development/creds/temp-users
#     vault read ldap-development/creds/temp-users
    
#     # List active leases by environment
#     vault list sys/leases/lookup/ldap-production/creds/
#     vault list sys/leases/lookup/ldap-development/creds/
#   EOT
# }

# output "library_checkout_demo_commands" {
#   description = "Commands to demonstrate service account check-out across environments"
#   value = <<-EOT
#     # Production Library Check-out (1h-2h checkout periods)
#     vault read ldap-library/library/production-library/check-out
#     vault read ldap-library/library/production-library/status
    
#     # Development Library Check-out (2h-4h checkout periods)
#     vault read ldap-library/library/development-library/check-out  
#     vault read ldap-library/library/development-library/status
    
#     # Force check-in examples (using service account names)
#     vault write ldap-library/library/production-library/check-in service_account_names=lib-svc-account1
#     vault write ldap-library/library/development-library/check-in service_account_names=lib-svc-account4
    
#     # Check overall library status
#     vault read ldap-library/library/production-library/status
#     vault read ldap-library/library/development-library/status
#   EOT
# }

# output "ldap_secrets_summary" {
#   description = "Summary of enterprise LDAP secrets engine configuration"
#   value = <<-EOT
#     Enterprise LDAP Secrets Engine Demo Configuration:
    
#     === STATIC CREDENTIALS (Auto-Rotating Service Accounts) ===
#     Production Environment (ldap-production):
#     - svc-account1, svc-account2, svc-account3
#     - Rotation: Every 24 hours (86400 seconds)
#     - Location: ou=production,ou=service-accounts,dc=hashibank,dc=com
    
#     Development Environment (ldap-development):  
#     - svc-account4, svc-account5, svc-account6
#     - Rotation: Every 4 hours (14400 seconds)
#     - Location: ou=development,ou=service-accounts,dc=hashibank,dc=com
    
#     === DYNAMIC CREDENTIALS (Temporary Account Creation) ===
#     Production Environment (ldap-production):
#     - Role: temp-users
#     - TTL: 30min-2h (shorter lived for production)
#     - Creates temporary accounts in: ou=production,ou=service-accounts,dc=hashibank,dc=com
    
#     Development Environment (ldap-development):
#     - Role: temp-users  
#     - TTL: 2h-8h (longer lived for development/testing)
#     - Creates temporary accounts in: ou=development,ou=service-accounts,dc=hashibank,dc=com
    
#     === LIBRARY CHECK-OUT/CHECK-IN (Shared Service Account Access) ===
#     Production Library (ldap-library):
#     - Library: production-library
#     - Accounts: lib-svc-account1, lib-svc-account2, lib-svc-account3
#     - Checkout TTL: 1h-2h
#     - Location: ou=production,ou=library-accounts,dc=hashibank,dc=com
    
#     Development Library (ldap-library):
#     - Library: development-library
#     - Accounts: lib-svc-account4, lib-svc-account5, lib-svc-account6
#     - Checkout TTL: 2h-4h
#     - Location: ou=development,ou=library-accounts,dc=hashibank,dc=com
    
#     All accounts are properly segregated with enterprise OU structure ensuring
#     complete separation between production and development environments.
#   EOT
# }
