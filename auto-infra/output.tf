output "alb_dns" {
  value = aws_lb.alb.dns_name
}

output "master_ip" {
  value = aws_instance.master.public_ip
}

output "worker_ips" {
  value = aws_instance.workers[*].public_ip
}

