# Authentication is provided via environment variables rather than provider
# arguments, so no secrets need to live in this configuration, e.g.:
#
#   Key flow:
#     STACKIT_SERVICE_ACCOUNT_KEY_PATH, STACKIT_PRIVATE_KEY_PATH
#
#   Workload Identity Federation:
#     STACKIT_USE_OIDC=true, STACKIT_SERVICE_ACCOUNT_EMAIL,
#     STACKIT_SERVICE_ACCOUNT_FEDERATED_TOKEN(_PATH)
#
# See https://registry.terraform.io/providers/stackitcloud/stackit/latest/docs
# for the full authentication reference.
provider "stackit" {
  default_region = var.region
}
