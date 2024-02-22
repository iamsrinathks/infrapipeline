#!/bin/bash

# Find all kustomization.yaml files under envs and iterate over them
find envs -type f -name 'kustomization.yaml' -print0 | while IFS= read -r -d '' kustomization_file; do
    # Extract the directory containing the kustomization.yaml file
    cluster_folder=$(dirname "${kustomization_file}")

    # Create destination directory
    mkdir -p "manifests/${cluster_folder}"

    # Copy the template to the destination
    cp "templates/manifest-kustomize.yaml" "manifests/${cluster_folder}/kustomization.yaml"

    # Run kustomize and output to bootstrap.yaml
    (cd "${cluster_folder}" && kubectl kustomize --enable-helm -o "../../../../manifests/${cluster_folder}/bootstrap.yaml")
done
