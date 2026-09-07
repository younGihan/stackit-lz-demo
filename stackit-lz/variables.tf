variable "workspace_name" {
  description = "Identifier of the existing meshWorkspace that will own the new meshProject and meshTenant."
  type        = string
}

variable "project_name" {
  description = "Identifier (metadata.name) for the new meshProject."
  type        = string
}

variable "project_display_name" {
  description = "Human-readable display name for the new meshProject."
  type        = string
}

variable "payment_method_identifier" {
  description = "Identifier of an existing meshPaymentMethod owned by workspace_name, assigned to the new meshProject."
  type        = string
}

variable "platform_identifier" {
  description = "Full identifier of the existing platform to deploy the tenant on, in the form '<platform-name>.<location-name>'."
  type        = string
}

variable "landing_zone_identifier" {
  description = "Identifier (metadata.name) of the existing landing zone to assign to the new meshTenant."
  type        = string
}

variable "building_block_definition_display_name" {
  description = "Display name of the existing building block definition to instantiate as the dummy building block."
  type        = string
}

variable "building_block_display_name" {
  description = "Display name shown in meshPanel for the dummy building block."
  type        = string
  default     = "dummy-building-block"
}

variable "building_block_inputs" {
  description = <<-EOT
    User inputs for the dummy building block, keyed by input name. Each value must set either
    `value = jsonencode(...)` or `sensitive = { secret_value = "..." }`, matching the inputs
    declared by the referenced building block definition. Left empty by default for a minimal dummy block.
  EOT
  type        = any
  default     = {}
}
