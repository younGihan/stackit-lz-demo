variable "organization_id" {
  description = "STACKIT organization ID that the network area and project belong to."
  type        = string
}

variable "parent_container_id" {
  description = "Parent resource container (organization or folder) identifier under which the project is created. Accepts either the user-friendly container ID or the UUID."
  type        = string
}

variable "region" {
  description = "STACKIT region used for the network area region config and all networks."
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
  description = "Additional labels to attach to the project. The 'networkArea' label is set automatically to bind the project to the created network area."
  type        = map(string)
  default     = {}
}

variable "network_area_name" {
  description = "Name of the STACKIT Network Area (SNA) that the project is assigned to."
  type        = string
}

variable "network_area_labels" {
  description = "Additional labels to attach to the network area."
  type        = map(string)
  default     = {}
}

variable "transfer_network" {
  description = "IPv4 CIDR used as the transfer network for the network area region."
  type        = string
  default     = "192.168.0.0/24"
}

variable "network_area_ranges" {
  description = "List of IPv4 CIDR prefixes reserved for the network area. VPC subnets must fall within these ranges."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "default_nameservers" {
  description = "Default IPv4 nameservers for networks created in this network area."
  type        = list(string)
  default     = ["8.8.8.8", "9.9.9.9"]
}

variable "default_prefix_length" {
  description = "Default IPv4 prefix length for networks created in this network area."
  type        = number
  default     = 25
}

variable "min_prefix_length" {
  description = "Minimum allowed IPv4 prefix length for networks in this network area."
  type        = number
  default     = 24
}

variable "max_prefix_length" {
  description = "Maximum allowed IPv4 prefix length for networks in this network area."
  type        = number
  default     = 29
}

variable "vpcs" {
  description = "Map of VPCs (STACKIT networks) to create in the project, keyed by network name, each with its own subnet CIDR. Every ipv4_prefix must fall within network_area_ranges."
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
