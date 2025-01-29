# Get all YAML files in the specified directory
locals {
  manifest_files = fileset(var.manifest_directory, "*.yaml")
}

# Read and decode each manifest file
locals {
  decoded_manifests = flatten([
    for file in local.manifest_files : provider::kubernetes::manifest_decode_multi(file("${var.manifest_directory}/${file}"))
  ])
}

# Create Kubernetes resources for each manifest
resource "kubernetes_manifest" "resources" {
  for_each = { for idx, manifest in local.decoded_manifests : idx => manifest }
  
  manifest = each.value
}

# Output the applied resources
output "applied_manifests" {
  value = { for k, v in kubernetes_manifest.resources : k => v.object }
}
