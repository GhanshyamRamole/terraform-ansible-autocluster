region = "us-east-1"
ami    = "ami-068c0051b15cdb816"                    # Ensure this AMI is valid for your region
instance_type = "t2.micro"
public_key_path = "~/.ssh/id_rsa.pub"               # Update to point to your actual local key

# Your existing VPC ID
vpc_id = "vpc-091692abf2042ee22" 
worker_count="3"

# Your existing Public Subnets
subnets = [
  "subnet-0732b4b4a7a13aa73",
  "subnet-094abdd789c6585d8"
]

tags = {
  Project     = "terraform-ansible-autocluster"
  Environment = "dev"
  Owner       = "Ghanshyam"
}
