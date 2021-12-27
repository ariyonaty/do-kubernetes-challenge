# Kubernetes cluster on DO
resource "digitalocean_kubernetes_cluster" "kube_cluster" {
  name    = "do-kubernetes-challenge"
  region  = var.region
  version = var.kube_version

  tags = ["test"]

  node_pool {
    name       = "worker-pool"
    size       = var.slug_size
    node_count = var.node_count
    auto_scale = false
    tags       = ["node-pool-tag"]
  }
}

output "cluster-id" {
  value = digitalocean_kubernetes_cluster.kube_cluster.id
}
