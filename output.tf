output "public_key" {
  description = "EC2 public key"
  value       = tls_private_key.custom_key.public_key_openssh
}

output "private_key" {
  description = "EC2 private key"
  value       = tls_private_key.custom_key.private_key_pem
  sensitive   = true
}

