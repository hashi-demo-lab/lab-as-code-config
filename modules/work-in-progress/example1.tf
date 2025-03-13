# locals {
#   # Get all YAML files in the subdirectory.
#   team_files = fileset("${path.module}/subdir", "*.yaml")

#   approved_clusters = [
#     "cluster1.example.com",
#     "cluster2.example.com",
#     "cluster3.example.com",
#     "cluster4.example.com"
#   ]
# }

# # Create a validation resource for each file.
# resource "null_resource" "validate_jwt_clusters" {
#   for_each = { for file in local.team_files : file => file }

#   lifecycle {
#     precondition {
#       condition = alltrue([
#         for fqdn in yamldecode(file("${path.module}/subdir/${each.value}"))["jwt_auth"]["allowed_clusters"] :
#         contains(local.approved_clusters, fqdn)
#       ])
#       error_message = "File ${each.value}: One or more clusters are not approved. Approved clusters: ${join(", ", local.approved_clusters)}."
#     }
#   }
# }

# # Output the allowed clusters for each team.
# output "jwt_allowed_clusters" {
#   value = {
#     for f in local.team_files :
#     f => yamldecode(file("${path.module}/subdir/${f}"))["jwt_auth"]["allowed_clusters"]
#   }
# }
