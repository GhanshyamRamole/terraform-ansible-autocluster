##################################
# AWS Configuration
##################################

region = "us-east-1"

# Amazon Linux 2 AMI (example – change if needed)
ami = "ami-068c0051b15cdb816"

instance_type = "t2.micro"

##################################
# SSH Key Configuration
##################################

# Path to your PUBLIC SSH key
public_key_path = "~/.ssh/terraform-key.pub"

##################################
# EC2 Configuration
##################################

worker_count = 2

##################################
# Networking Configuration
##################################

# Existing VPC ID
vpc_id = "vpc-091692abf2042ee22"

# Public subnets (at least 2 for ALB)
subnets = [
  "subnet-0732b4b4a7a13aa73",
  "subnet-094abdd789c6585d8"
]

##################################
# Resource Tags
##################################

tags = {
  Project     = "terraform-ansible-autocluster"
  Environment = "dev"
  Owner       = "Ghanshyam"
}

