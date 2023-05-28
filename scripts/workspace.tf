# Switch to a temporary workspace for file copying and placeholder replacement
terraform {
  required_version = ">= 0.12"
}

terraform {
  workspace = "temp_workspace"
}

provider "null" {}

resource "null_resource" "copy_and_generate_firewalls" {
  triggers = {
    folder_path = "${path.module}/firewalls"
  }

  provisioner "local-exec" {
    command = <<EOT
      mkdir -p "${self.triggers.folder_path}"
      cp -R "${path.module}/fw_templates"/*.tftpl "${self.triggers.folder_path}/"
      for file in "${self.triggers.folder_path}"/*.tftpl; do
        destination_file="${self.triggers.folder_path}/$$(basename "$${file%.*}").yaml"
        cp "$$file" "$$destination_file"
        sed -i "s|sourceip|$$\{module.ipam.cidr_range\}|g" "$$destination_file"
      done
    EOT
  }
}

# Switch back to the default workspace for provisioning firewall rules
terraform {
  workspace = "default"
}

module "firewall_module" {
  source = "path/to/firewall_module"

  firewalls = fileset("${path.module}/firewalls", "*.yaml")
}
