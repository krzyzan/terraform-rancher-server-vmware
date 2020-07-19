# Creates the VM inventory folder
resource "vsphere_folder" "folder" {
  path          = var.vsphere_folder
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Creates and provisions VM by cloning a RancherOS template in vSphere
resource "vsphere_virtual_machine" "vm" {
  name             = var.guest_hostname
  resource_pool_id = local.pool_id
  #resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 1
  memory = 4096
  guest_id = data.vsphere_virtual_machine.template.guest_id
  scsi_type = data.vsphere_virtual_machine.template.scsi_type
  enable_disk_uuid = true

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    linked_clone  = false
  }

  extra_config = {
    "guestinfo.cloud-init.config.data" = "${base64encode("${data.template_file.vm.rendered}")}"
    "guestinfo.cloud-init.data.encoding" = "base64"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo echo '${var.guest_authorized_ssh_key}' > /home/rancher/.ssh/authorized_keys",
      "sudo ros config set ssh_authorized_keys ['${var.guest_authorized_ssh_key}']",
    ]

    connection {
      type        = "ssh"
      host        = "${var.guest_hostname}.${var.guest_domain}"
      user        = "rancher"
      private_key = tls_private_key.provisioning_key.private_key_pem
    }
  }
}
