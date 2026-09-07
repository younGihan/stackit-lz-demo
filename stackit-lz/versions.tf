terraform {
  required_version = ">= 1.5"

  required_providers {
    meshstack = {
      source  = "meshcloud/meshstack"
      version = "~> 0.25"
    }
  }
}
