terraform {
  required_providers {
    morpheus = {
      source  = "gomorpheus/morpheus"
      version = "~> 0.29.0"
    }
  }
}

provider "morpheus" {
  }

data "morpheus_group" "Group" {
  name = "Vmware Group"
}

data "morpheus_cloud" "Cloud" {
  name = "Vmware Cloud"
}

data "morpheus_resource_pool" "Pool" {
# name     = "Morpheus-Cluster"
  name    = "CL1"
  cloud_id = data.morpheus_cloud.Cloud.id
}

data "morpheus_instance_type" "centos" {
  name = "CentOS"
}

data "morpheus_instance_layout" "Layout" {
  name               = "ESXi VM"
  version            = "9-stream"
}

data "morpheus_plan" "Plan" {
  name           = "G1-Small"
  provision_type = "vmware"
}

resource "morpheus_vsphere_instance" "tf_example_instance" {
  name               = "tfInstance"
  description        = "Terraform instance example"
  cloud_id           = data.morpheus_cloud.Cloud.id
  group_id           = data.morpheus_group.Group.id
  instance_type_id   = data.morpheus_instance_type.centos.id
  instance_layout_id = data.morpheus_instance_layout.Layout.id
  plan_id            = data.morpheus_plan.Plan.id
  resource_pool_id   = data.morpheus_resource_pool.Pool.id
 }
