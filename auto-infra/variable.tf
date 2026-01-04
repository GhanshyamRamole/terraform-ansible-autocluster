############################
# AWS Configuration
############################

variable "region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "ami" {
  description = "AMI ID for EC2 instances (Amazon Linux 2)"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

############################
# SSH Configuration
############################

variable "public_key_path" {
  description = "Path to the public SSH key"
  type        = string
}

############################
# EC2 Configuration
############################

variable "worker_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 2
}

############################
# Networking (ALB)
############################

variable "vpc_id" {
  description = "VPC ID where resources will be deployed"
  type        = string
}

variable "subnets" {
  description = "List of public subnet IDs for ALB"
  type        = list(string)
}

############################
# Tags (Optional but Recommended)
############################

variable "tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default = {
    Project     = "terraform-ansible"
    Environment = "dev"
  }
}

