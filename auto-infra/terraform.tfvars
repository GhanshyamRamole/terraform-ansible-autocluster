##################################
# AWS Configuration
##################################

region = "us-east-1"

# Amazon Linux 2 AMI (example – change if needed)
ami = "ami-0c02fb55956c7d316"

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
vpc_id = "vpc-0abc1234def567890"

# Public subnets (at least 2 for ALB)
subnets = [
  "subnet-0123456789abcdef0",
  "subnet-0fedcba9876543210"
]

##################################
# Resource Tags
##################################

tags = {
  Project     = "terraform-ansible-autocluster"
  Environment = "dev"
  Owner       = "Ghanshyam"
}

