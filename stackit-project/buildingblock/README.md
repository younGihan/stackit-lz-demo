# STACKIT Project Building Block

Creates a STACKIT project that is assigned to a STACKIT Network Area (SNA),
plus 4 VPCs (STACKIT networks) with their own subnets inside that project.

## Resources created

- `stackit_network_area` - the SNA
- `stackit_network_area_region` - regional IPv4 config (transfer network, reserved ranges, nameservers, prefix length bounds) for the SNA
- `stackit_resourcemanager_project` - the project, bound to the SNA via the `networkArea` label
- `stackit_network` (x4, via `for_each` over `var.vpcs`) - the VPCs, each with its own subnet CIDR

## Usage

```hcl
module "project" {
  source = "./stackit-project-buildingblock"

  organization_id      = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  parent_container_id  = "example-parent-container-abc123"
  project_name         = "example-project"
  owner_email          = "jane.doe@example.com"
  network_area_name    = "example-network-area"

  vpcs = {
    "vpc-frontend" = { ipv4_prefix = "10.0.1.0/24" }
    "vpc-backend"  = { ipv4_prefix = "10.0.2.0/24" }
    "vpc-data"     = { ipv4_prefix = "10.0.3.0/24" }
    "vpc-mgmt"     = { ipv4_prefix = "10.0.4.0/24", routed = true }
  }
}
```

Or run this directory directly as a root module (`terraform init && terraform apply`)
with a `terraform.tfvars` providing at least `organization_id`, `parent_container_id`,
`project_name`, `owner_email` and `network_area_name`.

## Authentication

Provider authentication is configured entirely via environment variables (see
[`provider.tf`](./provider.tf)), so no credentials need to be set in this
configuration. Either the STACKIT key flow
(`STACKIT_SERVICE_ACCOUNT_KEY_PATH`, `STACKIT_PRIVATE_KEY_PATH`) or Workload
Identity Federation (`STACKIT_USE_OIDC`, `STACKIT_SERVICE_ACCOUNT_EMAIL`,
`STACKIT_SERVICE_ACCOUNT_FEDERATED_TOKEN(_PATH)`) can be used. See the
[provider docs](https://registry.terraform.io/providers/stackitcloud/stackit/latest/docs)
for details.

## Subnet planning

`var.network_area_ranges` (default `10.0.0.0/16`) defines the address space
reserved for the network area. Each VPC's `ipv4_prefix` in `var.vpcs` must be
a subnet within that space - the defaults use `10.0.1.0/24` .. `10.0.4.0/24`.
