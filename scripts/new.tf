data "local_file" "firewall_templates" {
  directory_path = "${path.module}/fw_templates"
  include        = ["*.tftpl"]
}

resource "null_resource" "generate_firewalls" {
  triggers = {
    templates_hash = data.local_file.firewall_templates.sha1
  }

  provisioner "local-exec" {
    command = <<EOT
      mkdir -p "${path.module}/firewalls"

      for file in ${path.module}/fw_templates/*.tftpl; do
        destination_file="${path.module}/firewalls/$$(basename "$$file" .tftpl).yaml"

        sed "s|sourceip|$${module.ipam.cidr_range}|g" "$$file" > "$$destination_file"
      done
    EOT
  }
}

module "firewall_module" {
  source    = "path/to/firewall_module"
  firewalls = fileset("${path.module}/firewalls", "*.yaml")
}
