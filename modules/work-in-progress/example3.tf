# variable "vault_onboarding_yaml_paths" {
#   type        = list(string)
#   description = "List of relative paths to team YAML files."
#   default     = [
#     "subdir/teamA.yaml",
#     "subdir/teamB.yaml"
#   ]

#   validation {
#     condition = alltrue([
#       for p in var.vault_onboarding_yaml_paths : (
#         length(yamldecode(file("${path.module}/${p}"))["jwt_auth"]["allowed_clusters"]) > 0 &&
#         alltrue([
#           for cluster in yamldecode(file("${path.module}/${p}"))["jwt_auth"]["allowed_clusters"] :
#           contains(
#             ["cluster1.example.com", "cluster2.example.com", "cluster3.example.com", "cluster4.example.com"],
#             cluster
#           )
#         ])
#       )
#     ])
#     error_message = "One or more YAML files have disapproved clusters. Approved clusters: cluster1.example.com, cluster2.example.com, cluster3.example.com, cluster4.example.com."
#   }
# }

# locals {
#   team_configs = {
#     for p in var.vault_onboarding_yaml_paths :
#     p => yamldecode(file("${path.module}/${p}"))
#   }
# }

# output "jwt_allowed_clusters" {
#   value = { for p, cfg in local.team_configs : p => cfg["jwt_auth"]["allowed_clusters"] }
# }

variable "vault_onboarding_yaml_paths" {
  type        = list(string)
  description = "List of relative paths to team YAML files."
  default     = [
    "subdir/teamA.yaml",
    "subdir/teamB.yaml"
  ]

  validation {
    condition = alltrue([
      for p in var.vault_onboarding_yaml_paths : (
        length(yamldecode(file("${path.module}/${p}"))["jwt_auth"]["allowed_clusters"]) > 0 &&
        alltrue([
          for cluster in yamldecode(file("${path.module}/${p}"))["jwt_auth"]["allowed_clusters"] :
          contains(
            ["cluster1.example.com", "cluster2.example.com", "cluster3.example.com", "cluster4.example.com"],
            cluster
          )
        ])
      )
    ])
    error_message = format(
      "The following YAML file(s) have disapproved clusters: %s. Approved clusters: cluster1.example.com, cluster2.example.com, cluster3.example.com, cluster4.example.com.",
      join(", ", [
        for p in var.vault_onboarding_yaml_paths :
        p if !(
          length(yamldecode(file("${path.module}/${p}"))["jwt_auth"]["allowed_clusters"]) > 0 &&
          alltrue([
            for cluster in yamldecode(file("${path.module}/${p}"))["jwt_auth"]["allowed_clusters"] :
            contains(
              ["cluster1.example.com", "cluster2.example.com", "cluster3.example.com", "cluster4.example.com"],
              cluster
            )
          ])
        )
      ])
    )
  }
}

locals {
  team_configs = {
    for p in var.vault_onboarding_yaml_paths :
    p => yamldecode(file("${path.module}/${p}"))
  }
}

output "jwt_allowed_clusters" {
  value = { for p, cfg in local.team_configs : p => cfg["jwt_auth"]["allowed_clusters"] }
}

