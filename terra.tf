provider "vsphere" {
  user                 = "administrator@vsphere.local"
  password             = "Password!234"
  vsphere_server       = "vcsa8.can.cs8.local"
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "AMVLAB"
}

data "vsphere_datastore" "datastore" {
  name          = "vsanDatastore"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = "CL1"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = "Resources"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = "dc-mgmt"
  datacenter_id = data.vsphere_datacenter.dc.id
}


data "vsphere_virtual_machine" "template" {
  name          = "ubuntu-down"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm" {
  name             = "morpheus-tf-vm"
  guest_id = "ubuntu64Guest"
  num_cpus  = 1
  memory  = 1024
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id

network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

 disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks[0].size
    thin_provisioned = true
  }

    clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  }
}
