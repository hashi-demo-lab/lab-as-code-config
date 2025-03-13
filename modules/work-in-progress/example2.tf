# variable "vault_onboarding_yaml" {
#   type        = string
#   description = "Vault onboarding configuration in YAML format"
#   default = ""

#   validation {
#     condition = (
#       length([
#         for cluster in yamldecode(var.vault_onboarding_yaml)["jwt_auth"]["allowed_clusters"] :
#         cluster if !contains(["cluster1.example.com", "cluster2.example.com", "cluster3.example.com", "cluster4.example.com"], cluster)
#       ]) == 0
#     )
#     error_message = "Invalid cluster(s): ${join(", ", [
#       for cluster in yamldecode(var.vault_onboarding_yaml)["jwt_auth"]["allowed_clusters"] :
#       cluster if !contains(["cluster1.example.com", "cluster2.example.com", "cluster3.example.com", "cluster4.example.com"], cluster)
#     ])}. Approved clusters: cluster1.example.com, cluster2.example.com, cluster3.example.com, cluster4.example.com."
#   }
# }
