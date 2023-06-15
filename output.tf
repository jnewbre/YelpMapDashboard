output "public_key" {
  description = "EC2 public key"
  value       = tls_private_key.custom_key.public_key_openssh
}

output "private_key" {
  description = "EC2 private key"
  value       = tls_private_key.custom_key.private_key_pem
  sensitive   = true
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.map_ec2.public_ip
}

