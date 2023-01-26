terraform {
  required_version = ">= 1.2.2"
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
      version = "~> 1.47.0"
    }
  }
}
