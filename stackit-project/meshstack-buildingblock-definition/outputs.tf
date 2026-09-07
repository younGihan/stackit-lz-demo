output "uuid" {
  description = "UUID of the created meshStack building block definition."
  value       = meshstack_building_block_definition.stackit_project.metadata.uuid
}

output "ref" {
  description = "Reference to this building block definition, for use in other definitions' dependency_refs."
  value       = meshstack_building_block_definition.stackit_project.ref
}

output "version_latest" {
  description = "Latest version (including drafts) of the building block definition."
  value       = meshstack_building_block_definition.stackit_project.version_latest
}
