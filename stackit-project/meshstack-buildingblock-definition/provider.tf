# Authentication is provided via environment variables rather than provider
# arguments, so no secrets need to live in this configuration:
#
#   MESHSTACK_ENDPOINT    - e.g. https://api.my.meshstack.io
#   MESHSTACK_API_KEY / MESHSTACK_API_SECRET   - API key/secret pair, or
#   MESHSTACK_API_TOKEN                        - API token
#
# See https://registry.terraform.io/providers/meshcloud/meshstack/latest/docs
# for details.
provider "meshstack" {}
