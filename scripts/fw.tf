resource "null_resource" "copy_and_provision_firewalls" {
  triggers = {
    folder_path = "${path.module}"
  }

  provisioner "local-exec" {
    command = "./process_firewalls.sh ${self.triggers.folder_path}/firewalls ${module.ipam.cidr_range}"
  }
}

module "firewall_module" {
  source = "path/to/firewall_module"

  firewalls = fileset("${path.module}/firewalls", "*.yaml")
}
