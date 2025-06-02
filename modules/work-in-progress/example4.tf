# locals {
#   # Read and decode the YAML file.
#   vault_yaml   = file("${path.module}/subdir/vault_onboarding.yaml")
#   vault_config = yamldecode(local.vault_yaml)

#   # Define the list of approved clusters.
#   approved_clusters = [
#     "cluster1.example.com",
#     "cluster2.example.com",
#     "cluster3.example.com",
#     "cluster4.example.com"
#   ]
# }

# resource "terraform_data" "validate_jwt_clusters" {
#   # Store the file content as input.
#   input = local.vault_yaml

#   # Trigger replacement if the allowed clusters change.
#   triggers_replace = [
#     join(",", local.vault_config["jwt_auth"]["allowed_clusters"])
#   ]

#   # Run a local-exec provisioner to validate the clusters.
#   provisioner "local-exec" {
#     command = <<EOT
# allowed=$(python3 -c "import sys, yaml; print(','.join(yaml.safe_load(sys.stdin)['jwt_auth']['allowed_clusters']))" < ${path.module}/subdir/vault_onboarding.yaml)
# approved="cluster1.example.com,cluster2.example.com,cluster3.example.com,cluster4.example.com"
# for cluster in $(echo $allowed | tr ',' '\n'); do
#   if ! echo $approved | grep -qw "$cluster"; then
#     echo "Invalid cluster: $cluster"
#     exit 1
#   fi
# done
# EOT
#   }
# }

# output "jwt_allowed_clusters" {
#   value = local.vault_config["jwt_auth"]["allowed_clusters"]
# }
