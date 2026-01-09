# Terraform Ansible Auto Cluster

An automated infrastructure deployment solution that provisions an Ansible cluster on AWS using Terraform, complete with load balancing and NGINX deployment.

## Architecture Overview

This project creates:
- **1 Ansible Master Node** - Controls and manages worker nodes
- **Multiple Worker Nodes** (configurable) - Target servers for deployments
- **Application Load Balancer** - Distributes traffic across worker nodes
- **Security Groups** - Network access controls
- **Automated NGINX Deployment** - Web server configuration via Ansible

## Prerequisites

- AWS CLI configured with appropriate permissions
- Terraform >= 1.0
- Ansible (for local testing)
- SSH key pair generated (`ssh-keygen -t rsa`)
- Existing VPC with public subnets

## Required AWS Permissions

Your AWS user/role needs permissions for:
- EC2 (instances, key pairs, security groups)
- ELB (load balancers, target groups)
- VPC (subnets, security groups)

## Quick Start

### 1. Clone and Configure

```bash
git clone <repository-url>
cd terraform-ansible-autocluster
```

### 2. Update Configuration

Edit `auto-infra/terraform.tfvars`:

```hcl
region = "us-east-1"
ami    = "ami-068c0051b15cdb816"  # Amazon Linux 2 AMI for your region
instance_type = "t2.micro"
public_key_path = "~/.ssh/id_rsa.pub"
vpc_id = "vpc-xxxxxxxxx"         # Your VPC ID
worker_count = 3

subnets = [
  "subnet-xxxxxxxxx",            # Your public subnet IDs
  "subnet-yyyyyyyyy"
]

tags = {
  Project     = "terraform-ansible-autocluster"
  Environment = "dev"
  Owner       = "YourName"
}
```

### 3. Deploy Infrastructure

```bash
cd auto-infra
terraform init
terraform plan
terraform apply
```

### 4. Access Your Cluster

After deployment, Terraform outputs:
- **ALB DNS Name** - Access your load-balanced NGINX servers
- **Master IP** - SSH to Ansible control node
- **Worker IPs** - Direct access to worker nodes

## Project Structure

```
terraform-ansible-autocluster/
├── auto-infra/                 # Terraform infrastructure code
│   ├── provider.tf            # AWS provider configuration
│   ├── variable.tf            # Input variables
│   ├── terraform.tfvars       # Variable values
│   ├── ec2.tf                 # EC2 instances (master & workers)
│   ├── alb.tf                 # Application Load Balancer
│   ├── security_group.tf      # Network security rules
│   ├── inventory_creation.tf  # Ansible inventory generation
│   ├── inventory.tpl          # Inventory template
│   ├── user_data.tftpl        # Master node initialization
│   └── output.tf              # Output values
└── ansible/                   # Ansible configuration
    ├── playbook.yml           # Main playbook
    └── nginx.yml              # NGINX installation tasks
```

## Configuration Details

### Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `region` | AWS region | `us-east-1` | No |
| `ami` | AMI ID for instances | - | Yes |
| `instance_type` | EC2 instance type | `t2.micro` | No |
| `public_key_path` | SSH public key path | - | Yes |
| `worker_count` | Number of worker nodes | `2` | No |
| `vpc_id` | VPC ID for deployment | - | Yes |
| `subnets` | Public subnet IDs | - | Yes |

### Security Configuration

The project creates a security group allowing:
- SSH (port 22) from anywhere
- HTTP (port 80) from anywhere
- All traffic between cluster nodes

**Note**: For production use, restrict SSH access to your IP range.

## Usage Examples

### SSH to Master Node
```bash
ssh -i ~/.ssh/id_rsa itsadmin@<master-ip>
```

### Run Ansible Commands
```bash
# On master node
cd /home/itsadmin/default
ansible all -m ping
ansible-playbook /path/to/playbook.yml
```

### Access Load Balanced Application
```bash
curl http://<alb-dns-name>
```

## Ansible Configuration

The master node is automatically configured with:
- Ansible installed and configured
- Inventory file with worker nodes
- SSH connectivity to all workers
- Default user: `itsadmin` (password: `111`)

### Default Inventory Structure
```ini
[web]
worker-1
worker-2
worker-3

[web:vars]
ansible_port=22
ansible_user=itsadmin
ansible_password=111
```

## Customization

### Adding More Services

1. Create new Ansible roles in `ansible/` directory
2. Update `ansible/playbook.yml` to include new roles
3. Modify security groups if additional ports needed

### Scaling Workers

Update `worker_count` in `terraform.tfvars` and run:
```bash
terraform plan
terraform apply
```

### Different Instance Types

Modify `instance_type` variable for different performance requirements.

## Troubleshooting

### Common Issues

1. **AMI Not Found**: Update AMI ID for your region
2. **SSH Connection Failed**: Check security group rules and key path
3. **Ansible Connection Issues**: Verify worker nodes are accessible from master

### Debugging Steps

```bash
# Check Terraform state
terraform show

# Verify AWS resources
aws ec2 describe-instances --filters "Name=tag:Project,Values=terraform-ansible-autocluster"

# Test Ansible connectivity
ansible all -m ping -v
```

## Security Considerations

- Change default passwords in production
- Restrict SSH access to specific IP ranges
- Use IAM roles instead of hardcoded credentials
- Enable CloudTrail for audit logging
- Consider using AWS Systems Manager Session Manager

## Cleanup

To destroy all resources:

```bash
cd auto-infra
terraform destroy
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues and questions:
- Check the troubleshooting section
- Review Terraform and Ansible logs
- Open an issue in the repository

---

**Note**: This project is designed for development and testing. For production use, implement additional security measures and monitoring.
