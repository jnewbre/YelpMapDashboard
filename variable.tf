variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "key_name" {
  description = "EC2 key name"
  type        = string
  default     = "sde-key"
}

variable "instance_type" {
  description = "Instance type for EMR and EC2"
  type        = string
  default     = "t2.micro"
}

variable "repo_url" {
  description = "Repository url to clone into production machine"
  type        = string
}

variable "alert_email_id" {
  description = "Email for alerts"
  type        = string
}