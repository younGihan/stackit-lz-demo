variable "organization_id" {
  description = "STACKIT organization ID that the existing network area and the project belong to."
  type        = string
}

variable "parent_container_id" {
  description = "Parent resource container (organization or folder) identifier under which the project is created. Accepts either the user-friendly container ID or the UUID."
  type        = string
}

variable "region" {
  description = "STACKIT region used for all networks."
  type        = string
  default     = "eu01"
}

variable "project_name" {
  description = "Name of the STACKIT project to create."
  type        = string
}

variable "owner_email" {
  description = "Email address of the project owner. Only considered during project creation."
  type        = string
}

variable "project_labels" {
  description = "Additional labels to attach to the project. The 'networkArea' label is set automatically to bind the project to the existing network area."
  type        = map(string)
  default     = {}
}

variable "network_area_id" {
  description = "ID of the existing STACKIT Network Area (SNA) that the project is assigned to. This building block does not create a network area - it must already exist, along with its regional IPv4 config (transfer network, reserved ranges), and each VPC's ipv4_prefix must fall within one of its reserved ranges."
  type        = string
}

variable "vpcs" {
  description = "Map of VPCs (STACKIT networks) to create in the project, keyed by network name, each with its own subnet CIDR. Every ipv4_prefix must fall within one of the existing network area's reserved ranges."
  type = map(object({
    ipv4_prefix      = string
    dhcp             = optional(bool, true)
    routed           = optional(bool, false)
    ipv4_nameservers = optional(list(string))
    labels           = optional(map(string), {})
  }))

  default = {
    "vpc-frontend" = {
      ipv4_prefix = "10.0.1.0/24"
    }
    "vpc-backend" = {
      ipv4_prefix = "10.0.2.0/24"
    }
    "vpc-data" = {
      ipv4_prefix = "10.0.3.0/24"
    }
    "vpc-mgmt" = {
      ipv4_prefix = "10.0.4.0/24"
      routed      = true
    }
  }
}
