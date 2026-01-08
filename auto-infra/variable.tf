variable "region" {
  description = "AWS region"
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

variable "public_key_path" {
  description = "Path to the public SSH key"
  type        = string
}

variable "worker_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 2
}

variable "vpc_id" {
  description = "VPC ID where resources will be deployed"
  type        = string
}

variable "subnets" {
  description = "List of public subnet IDs for ALB and Instances"
  type        = list(string)
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default = {
    Project     = "terraform-ansible"
    Environment = "dev"
  }
}
