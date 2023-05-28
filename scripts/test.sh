#!/bin/bash

# Create the destination folder
mkdir -p "${1}/firewalls"

# Copy the template files
cp -R ./firewall_templates/*.tftpl "${1}/firewalls"

# Iterate over the copied files and perform placeholder replacement
for file in "${1}/firewalls"/*.tftpl; do
  destination_file="${file%.tftpl}.yaml"
  cp "$file" "$destination_file"
  sed -i "s|sourceip|${2}|g" "$destination_file"
done
