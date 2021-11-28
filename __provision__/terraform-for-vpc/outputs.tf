output "ssh" {
  description = "ssh command"
  value       = "ssh -v -i ~/.ssh/${var.key-name}.pem ubuntu@${aws_instance.app-appserver.public_ip}"
}
