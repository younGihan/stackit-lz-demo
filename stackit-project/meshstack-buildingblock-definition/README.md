# meshStack Building Block Definition: STACKIT Project Landing Zone

Registers the [`../stackit-project-buildingblock`](../stackit-project-buildingblock)
Terraform module with meshStack as a `meshstack_building_block_definition`, so
platform teams can offer it as a self-service building block that provisions a
STACKIT project (with a Network Area and 4 VPCs/subnets) against a tenant.

## Usage

```hcl
module "stackit_project_bbd" {
  source = "./meshstack-buildingblock-definition"

  owned_by_workspace = "my-platform-team"
  repository_url      = "https://github.com/<org>/<repo>.git"
  ref_name            = "main"
  draft               = false # release immediately instead of leaving it a draft
}
```

Or run this directory directly (`terraform init && terraform apply`) providing
at least `owned_by_workspace` and `repository_url` via a `terraform.tfvars`.

`repository_url` must point at the git repository that contains this codebase;
`repository_path` (default `stackit-project-buildingblock`) is the path within
that repository to the wrapped module.

## How it maps to the wrapped module

Every key under `version_spec.inputs` in [`main.tf`](./main.tf) matches a
variable name in
[`../stackit-project-buildingblock/variables.tf`](../stackit-project-buildingblock/variables.tf).
meshStack's Terraform runner passes each input to the module as `TF_VAR_<key>`.
`network_area_ranges`, `default_nameservers` and `vpcs` are declared
`is_optional = true` with no `default_value`, so if a consumer leaves them
unset, the wrapped module's own Terraform defaults apply.

Outputs are read back from the wrapped module's outputs
(`project_id`, `container_id`, `network_area_id`, `vpcs`). `project_id` is
marked `assignment_type = "PLATFORM_TENANT_ID"` since this is a `TENANT_LEVEL`
building block that provisions the tenant itself.

## Authentication

Provider authentication is configured entirely via environment variables (see
[`provider.tf`](./provider.tf)):

- `MESHSTACK_ENDPOINT`
- `MESHSTACK_API_KEY` / `MESHSTACK_API_SECRET`, or `MESHSTACK_API_TOKEN`

Requires meshStack 2026.36.0 or later (for `is_optional` support on inputs).

## Notes

- `supported_platform_names` (default `["STACKIT"]`) must match the name of a
  `meshPlatformType` already configured in your meshStack instance.
- This resource is in **preview** per the
  [provider docs](https://registry.terraform.io/providers/meshcloud/meshstack/latest/docs/resources/building_block_definition) -
  breaking changes are possible without notice.
