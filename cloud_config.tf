# Renders the cloud-config file for VM
data "template_file" "vm" {
  template = "${file("${path.module}/files/cloud-config.tpl")}"

  vars = {
    authorized_key = "${tls_private_key.provisioning_key.public_key_openssh}"
    hostname = "${var.guest_hostname}"
    gateway = "${var.guest_default_gateway}"
    primary_ns = "${var.guest_primary_dns}"
    secondary_ns = "${var.guest_secondary_dns}"
    address = "${var.guest_static_ip}"
    domain = "${var.guest_domain}"
    letsencrypt_email = "${var.luadns_email}"
    letsencrypt_server = "${var.letsencrypt_server}"
    luadns_email = "${var.letsencrypt_email}"
    luadns_token = "${var.luadns_token}"
  }
}
