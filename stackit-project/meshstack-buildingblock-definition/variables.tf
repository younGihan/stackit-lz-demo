# --- Building block definition metadata & spec ---------------------------

variable "owned_by_workspace" {
  description = "Identifier of the meshStack workspace that owns this building block definition."
  type        = string
}

variable "display_name" {
  description = "Display name of the building block definition, as shown in meshPanel."
  type        = string
  default     = "STACKIT Project Landing Zone"
}

variable "description" {
  description = "Description of the building block definition, as shown in meshPanel."
  type        = string
  default     = "Provisions a STACKIT project assigned to a STACKIT Network Area (SNA), with 4 VPCs and their subnets."
}

variable "readme" {
  description = "Detailed readme/documentation in markdown format. Set to null to omit."
  type        = string
  default     = null
}

variable "target_type" {
  description = "Where building blocks of this definition can be attached. One of TENANT_LEVEL, WORKSPACE_LEVEL."
  type        = string
  default     = "TENANT_LEVEL"
}

variable "supported_platform_names" {
  description = "Names of the meshStack platform types this building block supports (required, non-empty, when target_type is TENANT_LEVEL)."
  type        = list(string)
  default     = ["STACKIT"]
}

variable "notification_subscribers" {
  description = "Subscribers to notify about events related to this building block. Prefix usernames with 'user:' and emails with 'email:'."
  type        = list(string)
  default     = []
}

variable "draft" {
  description = "Whether the created version is a draft. Set to false to release it immediately."
  type        = bool
  default     = true
}

# --- Terraform implementation ---------------------------------------------

variable "repository_url" {
  description = "Git repository URL containing the stackit-project-buildingblock Terraform code."
  type        = string
}

variable "repository_path" {
  description = "Path within the repository to the Terraform module implementing this building block."
  type        = string
  default     = "stackit-project-buildingblock"
}

variable "ref_name" {
  description = "Git reference (branch, tag, or commit) to use."
  type        = string
  default     = "main"
}

variable "terraform_version" {
  description = "Terraform version the runner uses to apply the implementation."
  type        = string
  default     = "1.9.0"
}

variable "async" {
  description = "Whether to run the Terraform implementation asynchronously."
  type        = bool
  default     = true
}

variable "use_mesh_http_backend_fallback" {
  description = "Whether to use meshStack's HTTP backend as fallback for persisting Terraform state."
  type        = bool
  default     = true
}

# --- Defaults for the wrapped STACKIT template's inputs --------------------
# These become the default_value of the corresponding user inputs below, and
# are passed to the stackit-project-buildingblock module as TF_VAR_<name>.

variable "default_region" {
  description = "Default STACKIT region offered to consumers."
  type        = string
  default     = "eu01"
}

variable "default_transfer_network" {
  description = "Default IPv4 transfer network CIDR offered to consumers."
  type        = string
  default     = "192.168.0.0/24"
}
