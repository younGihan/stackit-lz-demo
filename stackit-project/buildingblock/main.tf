# STACKIT Network Area (SNA) - organization-level network area that the
# project is assigned to via the "networkArea" label on the project.
resource "stackit_network_area" "this" {
  organization_id = var.organization_id
  name            = var.network_area_name
  labels          = var.network_area_labels
}

# Regional IPv4 configuration (transfer network, reserved ranges, nameservers,
# prefix length bounds) for the network area.
resource "stackit_network_area_region" "this" {
  organization_id = var.organization_id
  network_area_id = stackit_network_area.this.network_area_id
  region          = var.region

  ipv4 = {
    transfer_network = var.transfer_network
    network_ranges = [
      for prefix in var.network_area_ranges : { prefix = prefix }
    ]
    default_nameservers   = var.default_nameservers
    default_prefix_length = var.default_prefix_length
    min_prefix_length     = var.min_prefix_length
    max_prefix_length     = var.max_prefix_length
  }
}

# STACKIT project, assigned to the network area above.
# Setting the "networkArea" label at creation time is how a project is bound
# to a STACKIT Network Area - this cannot be changed afterwards.
resource "stackit_resourcemanager_project" "this" {
  parent_container_id = var.parent_container_id
  name                = var.project_name
  owner_email         = var.owner_email

  labels = merge(var.project_labels, {
    networkArea = stackit_network_area.this.network_area_id
  })

  depends_on = [stackit_network_area_region.this]
}

# 4 VPCs (STACKIT networks), each with its own subnet CIDR.
resource "stackit_network" "vpc" {
  for_each = var.vpcs

  project_id = stackit_resourcemanager_project.this.project_id
  region     = var.region
  name       = each.key

  ipv4_prefix      = each.value.ipv4_prefix
  dhcp             = each.value.dhcp
  routed           = each.value.routed
  ipv4_nameservers = each.value.ipv4_nameservers
  labels           = each.value.labels

  depends_on = [stackit_network_area_region.this]
}
