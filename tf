resource "null_resource" "copy_and_provision_firewalls" {
  triggers = {
    folder_path = "${path.module}/firewalls"
  }

  provisioner "local-exec" {
    command = <<EOT
      bash -c 'mkdir -p "${self.triggers.folder_path}" \
      && cp -R "${path.module}/fw_templates"/*.tftpl "${self.triggers.folder_path}/" \
      && for file in "${self.triggers.folder_path}"/*.tftpl; do \
           echo "Processing file: $$file" \
           && destination_file="${self.triggers.folder_path}/$$(basename "$${file%.*}").yaml" \
           && echo "Destination file: $$destination_file" \
           && cp "$$file" "$$destination_file" \
           && sed -i "s|sourceip|$${{replace(module.ipam.cidr_range, "/", "\\/")}}|g" "$$destination_file" \
           && cat "$$destination_file" \
         done'

      # Add the necessary commands to perform the GCP actions here
      # For example, you can use the GCP provider and resources to create the firewall rules
      
      # Example:
      # terraform init
      # terraform apply --auto-approve
    EOT
  }
}
