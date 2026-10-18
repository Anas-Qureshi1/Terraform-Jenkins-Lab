
output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.web.id
}

output "instance_type" {
  description = "EC2 instance type"
  value       = aws_instance.web.instance_type
}

output "availability_zone" {
  description = "EC2 availability zone"
  value       = aws_instance.web.availability_zone
}
