# Registers the ../stackit-project-buildingblock Terraform module as a
# meshStack Building Block Definition, so it can be ordered/run against
# STACKIT tenants from meshPanel.
resource "meshstack_building_block_definition" "stackit_project" {
  metadata = {
    owned_by_workspace = var.owned_by_workspace
  }

  spec = {
    display_name             = var.display_name
    description              = var.description
    readme                   = var.readme
    target_type              = var.target_type
    supported_platforms      = [for name in var.supported_platform_names : { name = name }]
    notification_subscribers = var.notification_subscribers
  }

  version_spec = {
    draft         = var.draft
    deletion_mode = "DELETE"

    implementation = {
      terraform = {
        terraform_version              = var.terraform_version
        repository_url                 = var.repository_url
        repository_path                = var.repository_path
        ref_name                       = var.ref_name
        async                          = var.async
        use_mesh_http_backend_fallback = var.use_mesh_http_backend_fallback
      }
    }

    # Each key below is passed to the underlying Terraform module as
    # TF_VAR_<key>, matching the variable names in
    # ../stackit-project-buildingblock/variables.tf.
    inputs = {
      organization_id = {
        display_name    = "STACKIT Organization ID"
        description     = "STACKIT organization ID that the network area and project belong to."
        type            = "STRING"
        assignment_type = "USER_INPUT"
        display_order   = 1
      }
      parent_container_id = {
        display_name    = "Parent Container ID"
        description     = "Parent resource container (organization or folder) under which the project is created."
        type            = "STRING"
        assignment_type = "USER_INPUT"
        display_order   = 2
      }
      project_name = {
        display_name                   = "Project Name"
        description                    = "Name of the STACKIT project to create."
        type                           = "STRING"
        assignment_type                = "USER_INPUT"
        value_validation_regex         = "^[a-z0-9-]+$"
        validation_regex_error_message = "Project name must contain only lowercase letters, numbers, and hyphens."
        display_order                  = 3
      }
      owner_email = {
        display_name    = "Owner Email"
        description     = "Email address of the project owner."
        type            = "STRING"
        assignment_type = "USER_INPUT"
        display_order   = 4
      }
      network_area_name = {
        display_name    = "Network Area Name"
        description     = "Name of the STACKIT Network Area (SNA) the project is assigned to."
        type            = "STRING"
        assignment_type = "USER_INPUT"
        display_order   = 5
      }
      region = {
        display_name    = "Region"
        description     = "STACKIT region used for the network area region config and all networks."
        type            = "STRING"
        assignment_type = "USER_INPUT"
        default_value   = jsonencode(var.default_region)
        display_order   = 6
      }
      transfer_network = {
        display_name    = "Transfer Network CIDR"
        description     = "IPv4 CIDR used as the transfer network for the network area region."
        type            = "STRING"
        assignment_type = "USER_INPUT"
        default_value   = jsonencode(var.default_transfer_network)
        display_order   = 7
      }
      network_area_ranges = {
        display_name    = "Network Area Ranges"
        description     = "JSON-encoded list of IPv4 CIDR prefixes reserved for the network area, e.g. [\"10.0.0.0/16\"]. Leave unset to use the module default."
        type            = "CODE"
        assignment_type = "USER_INPUT"
        is_optional     = true
        display_order   = 8
      }
      default_nameservers = {
        display_name    = "Default Nameservers"
        description     = "JSON-encoded list of default IPv4 nameservers, e.g. [\"8.8.8.8\",\"9.9.9.9\"]. Leave unset to use the module default."
        type            = "CODE"
        assignment_type = "USER_INPUT"
        is_optional     = true
        display_order   = 9
      }
      vpcs = {
        display_name    = "VPCs"
        description     = "JSON-encoded map of VPCs (name -> { ipv4_prefix, dhcp, routed, ipv4_nameservers, labels }). Leave unset to use the module default (4 VPCs with /24 subnets)."
        type            = "CODE"
        assignment_type = "USER_INPUT"
        is_optional     = true
        display_order   = 10
      }
    }

    # Read back from the outputs of ../stackit-project-buildingblock.
    outputs = {
      project_id = {
        display_name    = "STACKIT Project ID"
        type            = "STRING"
        assignment_type = "PLATFORM_TENANT_ID"
        display_order   = 1
      }
      container_id = {
        display_name    = "STACKIT Project Container ID"
        type            = "STRING"
        assignment_type = "NONE"
        display_order   = 2
      }
      network_area_id = {
        display_name    = "STACKIT Network Area ID"
        type            = "STRING"
        assignment_type = "NONE"
        display_order   = 3
      }
      vpcs = {
        display_name    = "Created VPCs"
        type            = "CODE"
        assignment_type = "NONE"
        display_order   = 4
      }
    }
  }
}
