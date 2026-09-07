# Existing STACKIT Network Area (SNA) that the project is assigned to. This
# building block does not create a network area - it must already exist and
# have its regional IPv4 config (transfer network, reserved ranges, ...)
# already set up via stackit_network_area_region.
data "stackit_network_area" "existing" {
  organization_id = var.organization_id
  network_area_id = var.network_area_id
}

# STACKIT project, assigned to the existing network area above.
# Setting the "networkArea" label at creation time is how a project is bound
# to a STACKIT Network Area - this cannot be changed afterwards.
resource "stackit_resourcemanager_project" "this" {
  parent_container_id = var.parent_container_id
  name                = var.project_name
  owner_email         = var.owner_email

  labels = merge(var.project_labels, {
    networkArea = data.stackit_network_area.existing.network_area_id
  })
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
}
