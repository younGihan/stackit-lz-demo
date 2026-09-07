output "project_id" {
  description = "UUID of the created STACKIT project."
  value       = stackit_resourcemanager_project.this.project_id
}

output "container_id" {
  description = "User-friendly container ID of the created STACKIT project."
  value       = stackit_resourcemanager_project.this.container_id
}

output "network_area_id" {
  description = "ID of the existing STACKIT Network Area (SNA) the project is assigned to."
  value       = data.stackit_network_area.existing.network_area_id
}

output "vpcs" {
  description = "Map of created VPCs (STACKIT networks), keyed by name."
  value = {
    for name, net in stackit_network.vpc : name => {
      network_id    = net.network_id
      ipv4_prefixes = net.ipv4_prefixes
      public_ip     = net.public_ip
    }
  }
}
