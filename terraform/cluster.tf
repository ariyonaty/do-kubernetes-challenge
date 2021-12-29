# Kubernetes cluster on DO
resource "digitalocean_kubernetes_cluster" "kube_cluster" {
  name    = var.cluster_name
  region  = var.region
  version = var.kube_version

  tags = ["k8s"]

  node_pool {
    name       = var.pool_name
    size       = var.slug_size
    node_count = var.node_count
    auto_scale = false
    tags       = ["node-pool-tag"]
  }
}


output "cluster-id" {
  value = digitalocean_kubernetes_cluster.kube_cluster.id
}
