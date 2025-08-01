# Simple Kubernetes manifest deployment module
# Processes both .yaml files and .yaml.tpl templates

locals {
  # Get all YAML files (excluding generated files)
  yaml_files = toset([
    for file in fileset(var.manifest_directory, "*.yaml") :
    file if !endswith(file, "-generated.yaml")
  ])
  
  # Get all template files  
  template_files = fileset(var.manifest_directory, "*.yaml.tpl")
  
  # Process template files
  rendered_templates = {
    for file in local.template_files :
    replace(file, ".tpl", "") => templatefile("${var.manifest_directory}/${file}", {
      ca_bundle         = base64encode(var.root_ca_cert)
      vault_server      = var.vault_server_url
      nextjs_image      = var.nextjs_image
      nextjs_tag        = var.nextjs_tag
      app_domain        = var.app_domain
      cert_issuer       = var.cert_issuer
      app_domain_secret = var.app_domain_secret
    })
  }
  
  # Read regular YAML files
  yaml_contents = {
    for file in local.yaml_files :
    file => file("${var.manifest_directory}/${file}")
  }
  
  # Combine all manifests (templates + regular yaml files)
  all_manifests = merge(local.yaml_contents, local.rendered_templates)
  
  # Decode all manifests into Kubernetes resources with unique keys
  decoded_manifests = flatten([
    for filename, content in local.all_manifests : [
      for idx, manifest in provider::kubernetes::manifest_decode_multi(content) : {
        key      = "${filename}-${idx}-${manifest.kind}-${lookup(manifest.metadata, "namespace", "default")}-${manifest.metadata.name}"
        manifest = manifest
      }
    ]
  ])
}

# Write rendered templates to disk for debugging/reference
resource "local_file" "rendered_templates" {
  for_each = local.rendered_templates
  
  content  = each.value
  filename = "${path.root}/manifests/${each.key}-generated.yaml"
}

# Deploy all Kubernetes resources
resource "kubernetes_manifest" "resources" {
  for_each = {
    for item in local.decoded_manifests :
    item.key => item.manifest
  }

  manifest = each.value
}

output "applied_manifests" {
  description = "List of applied Kubernetes manifests"
  value = {
    yaml_files      = local.yaml_files
    template_files  = local.template_files
    total_resources = length(local.decoded_manifests)
    resources       = { for k, v in kubernetes_manifest.resources : k => v.object }
  }
}
