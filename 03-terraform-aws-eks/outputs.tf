output "redacre_cluster_name" {
  value = aws_eks_cluster.redacre-cluster.name
}

output "redacre_cluster_endpoint" {
  value = aws_eks_cluster.redacre-cluster.endpoint
}