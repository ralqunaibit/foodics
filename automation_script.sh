#!/bin/bash

# go to ansible dir
cd ansible

# get the env vars
set -o allexport
source .env
set +o allexport

# Build and Push Docker Image
ansible-playbook build_and_push_image.yml -i inventory

# Check if the first playbook succeeded
if [ $? -eq 0 ]; then
  echo "Docker image built and pushed successfully."
  
  # Deploy to Kubernetes
  ansible-playbook deploy_to_k8s.yml -i inventory
  
  if [ $? -eq 0 ]; then
    echo "Application deployed to Kubernetes successfully."
  else
    echo "Failed to deploy the application to Kubernetes."
  fi
else
  echo "Failed to build and push Docker image."
fi
