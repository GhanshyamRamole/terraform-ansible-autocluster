resource "local_file" "inventory" {
  content = templatefile("${path.module}/inventory.tpl", {
    master_ip = aws_instance.master.public_ip
    worker_ips = aws_instance.workers[*].public_ip
  })
  filename = "../ansible/inventory.ini"
}

