# terraform-quake-azure
Example repo to run a Quake client and server on Azure and Azure Container Service with Terraform

1. Install Terraform
2. Create a storage account and fetch the Access Key for the environment variables.
3. Set the following environment variables for your account:
```
# Azure
export TF_VAR_subscription_id="xxxxxxxxxxxxxxxxxxxx"
export TF_VAR_client_id="xxxxxxxxxxxxxxxxxxxx"
export TF_VAR_client_secret="xxxxxxxxxxxxxxxxxxxx"
export TF_VAR_tenant_id="xxxxxxxxxxxxxxxxxxxx"

# FOR REMOTE STORAGE ACCOUNT
export ARM_ACCESS_KEY="xxxxxxxxxxxxxxxxxxxxx"
export REMOTE_STATE_ACCOUNT="storage_account_name"

# AWS
export AWS_ACCESS_KEY_ID=xxxxxxxxxxxxxxxxxxxxx
export AWS_SECRET_ACCESS_KEY=xxxxxxxxxxxxxxxxxxxxx
export AWS_REGION=eu-west-1
```

## Terraform Config
### Core [terraform/core](terraform/core)
- remote state
- resource group
- container service cluster

#### Running
```
 cd terraform/core

 # Set storage_account_name not supported currently by interpolation
 sed "s/nictfremotestate/$REMOTE_STATE_ACCOUNT/g" -i terraform.tf
 
 # Install modules and fetch plugins
 terraform init

 # Run a plan to see what changes will be made
 terraform plan

 # Apply the changes
 terraform apply
```

### K8s Service [terraform/k8s-service](terraform/k8s-service)
- references remote state in core
- k8s pod
- k8s service
- dns, AWS Route 53

#### Running
```
 cd terraform/k8s-service

 # Set storage_account_name not supported currently by interpolation
 sed "s/nictfremotestate/$REMOTE_STATE_ACCOUNT/g" -i terraform.tf

 # Install modules and fetch plugins
 terraform init

 # Run a plan to see what changes will be made
 terraform plan

 # Apply the changes
 terraform apply
```

### VM [terraform/vm](terraform/vm)
NOTE: this example attaches a snapshot from a private repository and can not be created, REFERENCE ONLY.
- references remote state in core
- Windows VM
- virtual network
- security group
- managed disks
- dns, AWS Route 53
