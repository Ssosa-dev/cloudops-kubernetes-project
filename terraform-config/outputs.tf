output "cluster_name" {
  description = "EKS Cluster Name"
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "API endpoint for EKS control plane"
  value       = aws_eks_cluster.main.endpoint
}

output "kubeconfig_update_command" {
  description = "CLI command to update local kubeconfig to connect kubectl"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${aws_eks_cluster.main.name}"
}