# Kubernetes cluster on DO
resource "digitalocean_kubernetes_cluster" "kube_cluster" {
  name    = "do-kubernetes-challenge"
  region  = var.region
  version = var.kube_version

  tags = ["test"]

  node_pool {
    name       = "worker-pool"
    size       = var.slug_size
    node_count = 2
    auto_scale = false
    tags       = ["node-pool-tag"]
  }
}

# Node pool 
resource "digitalocean_kubernetes_node_pool" "app_node_pool" {
  cluster_id = digitalocean_kubernetes_cluster.kube_cluster.id

  name       = "app-pool"
  size       = var.slug_size
  node_count = 2
  tags       = ["application"]

  labels = {
    service  = "application"
    priority = "high"
  }
}

output "cluster-id" {
  value = digitalocean_kubernetes_cluster.kube_cluster.id
}
