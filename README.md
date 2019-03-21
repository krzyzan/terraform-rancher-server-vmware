# terraform-rancher-server-vmware

Terraform code to provision Rancher Server 2.x on RencherOS in vSphere.
VM is created by cloning from a RancherOS template.
A cloud-config template is used to provide static IP address and other configuration.

## Prerequisites

### Create RancherOS template in vSphere

1. Download the RancherOS OVA appliance from: -TODO-
2. Import into vSphere ("Deploy OVF template...)
3. Mark the resulting VM as template ("Convert to template")
4. Note the name/path of the template which must be provided to Terraform

## Usage

1. Copy the `terraform.tfvars.example` to `terraform.tfvars` and adapt to match your environment
2. Specify the static IP configuration (`guest_static_ip`, `guest_default_gateway`)
3. Adapt the cloud-config template (`files/cloud-config.tpl`) to your needs
4. Run `terraform plan`
5. Run `terraform apply`
