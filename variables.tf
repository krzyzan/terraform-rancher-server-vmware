#-----------------------------------------#
# vCenter Configuration
#-----------------------------------------#

# vCenter username
variable "vcenter_user" {
  type = "string"
}

# vCenter user password
variable "vcenter_password" {
  type = "string"
}

# vCenter server FQDN or IP address
variable "vcenter_server" {
  type = "string"
}

#-----------------------------------------#
# vSphere Resource Configuration
#-----------------------------------------#

# vSphere datacenter to use
variable "vsphere_datacenter" {
  type = "string"
}

# vSphere cluster to use (required unless vsphere_host is specified)
variable "vsphere_cluster" {
  type = "string"
  default = ""
}

# vSphere ESXi host to use (required unless vsphere_cluster is specified)
variable "vsphere_host" {
  type = "string"
  default = ""
}

# Name/path of resource pool to create VMs in (not used atm)
variable "vsphere_resource_pool" {
  type = "string"
  default = ""
}

# Datastore to store VMs disk
variable "vsphere_datastore" {
  type = "string"
}

# VM Network to attach the VMs
variable "vsphere_network" {
  type = "string"
}

# Name/path of RancherOS vApp template from which to clone VMs
variable "vsphere_template" {
  type = "string"
}

# Name/path of vSphere inventory folder in which to organize the VMs
# Note: This folder will be created on terraform apply and removed on terraform destroy.
variable "vsphere_folder" {
  type = "string"
}

#-----------------------------------------#
# Guest OS configuration
#-----------------------------------------#

# The name of the K8s cluster to create in Rancher.
variable "guest_hostname" {
  type = "string"
}

# Static IP address in CIDR notation to assign to nodes.
variable "guest_static_ip" {
  type = "string"
}

# Default gateway IP address
variable "guest_default_gateway" {
  type = "string"
}

# Primary DNS server
variable "guest_primary_dns" {
  type = "string"
}

# Secondary DNS server
variable "guest_secondary_dns" {
  type = "string"
}

# Secondary DNS server
variable "guest_domain" {
  type = "string"
}

# SSH public key to authorize on all nodes
variable "guest_authorized_ssh_key" {
  type = "string"
}
