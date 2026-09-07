# --- Prerequisites (must already exist in meshStack) ---

data "meshstack_workspace" "this" {
  metadata = {
    name = var.workspace_name
  }
}

data "meshstack_payment_method" "this" {
  metadata = {
    name               = var.payment_method_identifier
    owned_by_workspace = var.workspace_name
  }
}

# Resolve the target platform by its full identifier ("<platform-name>.<location-name>") instead
# of hardcoding a uuid.
data "meshstack_platforms" "available" {
  owned_by_workspace = var.workspace_name
}

locals {
  platform = one([
    for p in data.meshstack_platforms.available.platforms : p
    if p.identifier == var.platform_identifier
  ])
}

data "meshstack_landingzones" "available" {
  platform_uuid = local.platform.metadata.uuid
}

locals {
  landing_zone = one([
    for lz in data.meshstack_landingzones.available.landing_zones : lz
    if lz.metadata.name == var.landing_zone_identifier
  ])
}

# --- meshProject ---

resource "meshstack_project" "this" {
  metadata = {
    name               = var.project_name
    owned_by_workspace = data.meshstack_workspace.this.metadata.name
  }

  spec = {
    display_name              = var.project_display_name
    payment_method_identifier = data.meshstack_payment_method.this.metadata.name
  }
}

# --- meshTenant ---

resource "meshstack_tenant" "this" {
  metadata = {
    owned_by_workspace = data.meshstack_workspace.this.metadata.name
    owned_by_project   = meshstack_project.this.metadata.name
  }

  spec = {
    platform_ref     = local.platform.ref
    landing_zone_ref = local.landing_zone.ref
  }

  wait_for_completion = true
}

# --- Dummy Building Block on the tenant ---

data "meshstack_building_block_definitions" "available" {
  workspace_identifier = var.workspace_name
}

locals {
  building_block_definition = one([
    for bbd in data.meshstack_building_block_definitions.available.building_block_definitions : bbd
    if bbd.spec.display_name == var.building_block_definition_display_name
  ])
}

resource "meshstack_building_block" "dummy" {
  spec = {
    building_block_definition_version_ref = {
      uuid = local.building_block_definition.version_latest.uuid
    }

    display_name = var.building_block_display_name

    target_ref = {
      kind = "meshTenant"
      uuid = meshstack_tenant.this.ref.uuid
    }

    inputs = var.building_block_inputs
  }

  wait_for_completion = true

  # FAILED/ABORTED runs fail the apply; WAITING_FOR_* states are left alone since they park until
  # someone acts in meshPanel (e.g. an operator input or approval).
  lifecycle {
    postcondition {
      condition     = !contains(["FAILED", "ABORTED"], self.status.status)
      error_message = "Building block ${self.metadata.uuid} is ${self.status.status}. See its run in meshPanel."
    }
  }
}
