#!/usr/bin/env bash

info() {
  echo "INFO: $1"
}

warning() {
  echo "WARNING: $1"
}

error() {
  echo "ERROR: $1"
  exit 1
}

createResources() {
  info "Initializing resources"

  cd "$(pwd)/bootstrap/terraform" || error "Could not cd into $(pwd)/bootstrap/terraform"
  terraform init -input=false -upgrade=true || error "Could not run terraform init"

  TF_VAR_terraform_workspace="bootstrap"

  info "switching to ${TF_VAR_terraform_workspace} workspace"
  terraform workspace select ${TF_VAR_terraform_workspace} \
    || terraform workspace new ${TF_VAR_terraform_workspace} \
    || error "failed to create and/or select ${TF_VAR_terraform_workspace} workspace"

  info "Planning the resources"
  terraform plan -input=false || error "Could not run terraform plan"

  info "Applying the plan"
  terraform apply -auto-approve -input=false || error "Could not run terraform apply"
}


cleanupResources() {
  info "cleaning up resources"

  cd "$(pwd)/bootstrap/terraform" \
    || error "could not switch to bootstrap Terraform code directory"
  terraform init -input=false \
    || error "failed to initialize Terraform in the $(pwd)/bootstrap/terraform directory"

  TF_VAR_terraform_workspace="bootstrap"

  info "destroying everything in the ${TF_VAR_terraform_workspace} workspace"
  terraform workspace select ${TF_VAR_terraform_workspace} \
    || error "failed to switch to the ${TF_VAR_terraform_workspace} workspace"
  terraform refresh
  terraform destroy -auto-approve -input=false \
    || error "failed to destroy Terraform resources in the ${TF_VAR_terraform_workspace} workspace"

    # if the selected workspace is empty, delete it, otherwise fail
  if [ "$(terraform state list 2> /dev/null)" == "" ]; then
    info "deleting the ${TF_VAR_terraform_workspace} workspace"
    terraform workspace select default \
      || error "failed to switch to the default workspace"
    terraform workspace delete ${TF_VAR_terraform_workspace} \
      || error "failed to delete workspace ${TF_VAR_terraform_workspace}"
  else
    error "workspace ${TF_VAR_terraform_workspace} is not empty"
  fi

  info "done cleaning up resources"
}


info "starting bootstrap"
info "bootstrap mode is ${TF_VAR_bootstrap_mode}"
eval $(minikube -p minikube docker-env)

if [[ "${TF_VAR_bootstrap_mode}" == "setup" ]]; then
  createResources
elif [[ "${TF_VAR_bootstrap_mode}" == "cleanup" ]]; then
  cleanupResources
else
  error "TF_VAR_bootstrap_mode: ${TF_VAR_bootstrap_mode} is unsupported"
fi
