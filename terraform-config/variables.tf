variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Base name for resource tagging and identification"
  type        = string
  default     = "cloudops-k8s"
}

variable "node_instance_type" {
  description = "EC2 instance type for EKS managed worker nodes"
  type        = string
  default     = "t3.medium"
}