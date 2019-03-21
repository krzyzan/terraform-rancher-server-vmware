output "default_ip_address" {
  value = "${formatlist("%v", vsphere_virtual_machine.vm.*.default_ip_address)}"
}
