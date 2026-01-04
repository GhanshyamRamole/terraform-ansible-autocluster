
	###########################################################
	# Provisioning of Ansible cluster Master and Worker nodes #
	###########################################################

resource "aws_key_pair" "key" {
  key_name   = "terraform-key"
  public_key = file(var.public_key_path)
}

resource "aws_instance" "master" {
  ami           = var.ami
  instance_type = "t2.micro"
  key_name      = aws_key_pair.key.key_name
  security_groups = [aws_security_group.common.name]

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y ansible python3 git
  EOF

  tags = {
    Name = "ansible-master"
  }
}

resource "aws_instance" "workers" {
  count         = var.worker_count
  ami           = var.ami
  instance_type = "t2.micro"
  key_name      = aws_key_pair.key.key_name
  security_groups = [aws_security_group.common.name]

  tags = {
    Name = "worker-${count.index}"
  }
}

