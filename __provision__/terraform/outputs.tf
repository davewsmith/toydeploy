output "ssh" {
  description = "ssh command"
  value       = "ssh -i ~/.ssh/${var.key_name}.pem ubuntu@${aws_instance.app_appserver.public_ip}"
}
