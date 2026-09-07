output "project_name" {
  description = "Identifier of the created meshProject."
  value       = meshstack_project.this.metadata.name
}

output "tenant_uuid" {
  description = "UUID of the created meshTenant."
  value       = meshstack_tenant.this.ref.uuid
}

output "tenant_status" {
  description = "Status of the created meshTenant."
  value       = meshstack_tenant.this.status
}

output "building_block_uuid" {
  description = "UUID of the dummy building block."
  value       = meshstack_building_block.dummy.metadata.uuid
}

output "building_block_status" {
  description = "Execution status of the dummy building block."
  value       = meshstack_building_block.dummy.status.status
}
