terraform {
  required_version = ">= 1.9.0"

  required_providers {
    meshstack = {
      source  = "meshcloud/meshstack"
      version = "~> 0.25"
    }
  }
}
