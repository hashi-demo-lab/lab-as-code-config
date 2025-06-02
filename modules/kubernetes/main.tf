# # Get all YAML files in the specified directory
# locals {
#   manifest_files = fileset(var.manifest_directory, "*.yaml")
  
#   # Convert manifest_files set to a map with all values set to true
#   manifest_files_map = {
#     for file in local.manifest_files : file => true
#   }
  
#   # Determine which manifests to deploy based on enable_manifests variable
#   # If enable_manifests is empty, use all manifests from manifest_files_map
#   # Otherwise, overlay the enable_manifests values onto manifest_files_map
#   manifests_to_deploy = length(var.enable_manifests) == 0 ? local.manifest_files_map : {
#     for file in local.manifest_files :
#     file => lookup(var.enable_manifests, file, lookup(var.enable_manifests, basename(file), true))
#   }
# }

# # Read and decode each manifest file
# locals {
#   dummy_manifest = provider::kubernetes::manifest_decode_multi("")

#   decoded_manifests = flatten([
#     for file in local.manifest_files :
#     (
#       lookup(local.manifests_to_deploy, file, false)
#       ? provider::kubernetes::manifest_decode_multi(file("${var.manifest_directory}/${file}"))
#       : local.dummy_manifest
#     )
#   ])
# }

locals {
  manifest_files = var.kubernetes_manifests_enabled ? fileset(var.manifest_directory, "*.yaml") : []
  decoded_manifests = flatten([
    for file in local.manifest_files :
    provider::kubernetes::manifest_decode_multi(file("${var.manifest_directory}/${file}"))
  ])
}

# Create Kubernetes resources for each manifest
resource "kubernetes_manifest" "resources" {
  for_each = {
    for manifest in local.decoded_manifests :
    "${manifest.kind}-${lookup(manifest.metadata, "namespace", "default")}-${manifest.metadata.name}" => manifest
  }

  manifest = each.value
}

output "applied_manifests" {
  value = { for k, v in kubernetes_manifest.resources : k => v.object }
}
