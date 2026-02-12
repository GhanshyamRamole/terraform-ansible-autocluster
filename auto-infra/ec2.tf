
	###########################################################
	# Provisioning of Ansible cluster Master and Worker nodes #
	###########################################################

resource "aws_key_pair" "key" {
  key_name   = "terraform-key-new"        # Changed name to avoid conflicts if recreating
  public_key = file(var.public_key_path)
}

resource "aws_instance" "workers" {
  count         = var.worker_count
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = aws_key_pair.key.key_name

  subnet_id              = element(var.subnets, count.index)
  vpc_security_group_ids = [aws_security_group.common.id]

  user_data = <<-EOF
  #!/bin/bash
  useradd itsadmin
  echo 111 | passwd --stdin itsadmin
  echo 111 | passwd --stdin root
  echo "itsadmin  ALL=(ALL)   NOPASSWD: ALL" >> /etc/sudoers
  sed 's/PasswordAuthentication no/PasswordAuthentication yes/' -i /etc/ssh/sshd_config
  echo PermitRootLogin yes >> /etc/ssh/sshd_config
  systemctl restart sshd
  EOF

  tags = merge(var.tags, { Name = "worker-${count.index + 1}" })
}
   


resource "aws_instance" "master" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = aws_key_pair.key.key_name
  
  subnet_id              = var.subnets[0]
  vpc_security_group_ids = [aws_security_group.common.id]
  
  user_data = templatefile("${path.module}/user_data.tftpl", {
    worker_ips = aws_instance.workers[*].private_ip
  })


  #  Define how Terraform connects to the instance
  connection {
    type        = "ssh"
    user        = "ec2-user"        # Default user for Amazon Linux 2
    private_key = file("~/.ssh/id_rsa") # Path to your PRIVATE key
    host        = self.public_ip
  }
  
  # Upload the ansible folder
  provisioner "file" {
    source      = "${path.module}/../ansible" # Local path to your ansible folder
    destination = "/home/ec2-user/ansible"    # Remote destination path
  }

  # Move folder to itsadmin user (after user_data creates the user)

  provisioner "remote-exec" {
    inline = [
      # Wait for the directory to be created (this waits for yum update to finish)
      "while ! sudo test -d /home/itsadmin/default; do echo 'Waiting for directory creation...'; sleep 10; done",

      # Safety buffer to ensure permissions are applied
      "sleep 10",

      # Now move the files and change ownership
      "sudo mv /home/ec2-user/ansible/* /home/itsadmin/default/",
      "sudo chown -R itsadmin:itsadmin /home/itsadmin/default/"
    ]
  }

  tags = merge(var.tags, { Name = "ansible-master" })
}
