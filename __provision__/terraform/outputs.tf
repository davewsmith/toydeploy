output "ssh" {
  description = "ssh command"
  value       = "ssh -i ~/.ssh/${var.key-name}.pem ubuntu@${aws_instance.app-appserver.public_ip}"
}
