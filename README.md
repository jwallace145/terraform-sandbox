# terraform-sandbox
## Terraform Commands
```bash
# plan commands
terraform plan -var-file=env/dev_east.tfvars
terraform plan -var-file=env/dev_west.tfvars
terraform plan -var-file=env/prod_east.tfvars
terraform plan -var-file=env/prod_west.tfvars

# apply commands
terraform apply -var-file=env/dev_east.tfvars
terraform apply -var-file=env/dev_west.tfvars
terraform apply -var-file=env/prod_east.tfvars
terraform apply -var-file=env/prod_west.tfvars

# destroy commands
terraform destroy -var-file=env/dev_east.tfvars
terraform destroy -var-file=env/dev_west.tfvars
terraform destroy -var-file=env/prod_east.tfvars
terraform destroy -var-file=env/prod_west.tfvars
```