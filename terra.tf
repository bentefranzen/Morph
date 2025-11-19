terraform {
  required_providers {
    morpheus = {
      source  = "gomorpheus/morpheus"
      version = " >= 0.12.0"
    }
  }
}

provider "morpheus" {
  url          = "https://emorph.can.cs8.local/"
  access_token = ""
  secure       = false
}


data "morpheus_group" "Group" {
  name = "VMware Group"
}

data "morpheus_cloud" "Cloud" {
  name = "VMware Cloud"
}

data "morpheus_resource_pool" "Pool" {
  name    = "CL1"
  cloud_id = data.morpheus_cloud.Cloud.id
}

data "morpheus_instance_type" "ubuntu" {
  name = "Ubuntu"
}

data "morpheus_instance_layout" "Layout" {
  name = "VMware VM"
  version = "24.04"
}

data "morpheus_network" "vmnetwork" {
  name = "dc-mgmt"
}

data "morpheus_plan" "Plan" {
  name           = "1 CPU, 2GB Memory"
  provision_type = "vmware"
}

resource "morpheus_vsphere_instance" "tf_example_instance" {
  name               = "tfInstance2"
  description        = "Terraform instance example"
  cloud_id           = data.morpheus_cloud.Cloud.id
  group_id           = data.morpheus_group.Group.id
  instance_type_id   = data.morpheus_instance_type.ubuntu.id
  instance_layout_id = data.morpheus_instance_layout.Layout.id
  plan_id            = data.morpheus_plan.Plan.id
  resource_pool_id   = data.morpheus_resource_pool.Pool.id
  interfaces {
    network_id = data.morpheus_network.vmnetwork.id
  }
}
