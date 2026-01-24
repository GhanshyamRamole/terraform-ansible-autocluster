terraform {
  backend "s3" {
    bucket       = "ansible-autocluster-bucket" 
    region       = "us-west-1"
    key          = "DevOps/ansible/terraform.tfstate"
    encrypt      = true
    
    # updated WAY configure backend:
    use_lockfile = true             
    # dynamodb_table = "Lock-Files"  
  }
}
