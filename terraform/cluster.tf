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


resource "digitalocean_firewall" "kube_firewall" {
  name        = "k8s-firewall"
  droplet_ids = [digitalocean_kubernetes_cluster.kube_cluster.node_pool[0].nodes[0].droplet_id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "31000"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
}

# resource "digitalocean_loadbalancer" "ingress" {
#   name   = "${var.cluster_name}-lb"
#   region = var.region

#   forwarding_rule {
#     entry_port     = 8080
#     entry_protocol = "http"

#     target_port     = 5000
#     target_protocol = "http"
#   }

#   # forwarding_rule {
#   #   entry_port     = 443
#   #   entry_protocol = "https"

#   #   target_port     = 5000
#   #   target_protocol = "https"
#   # }

#   healthcheck {
#     port     = 22
#     protocol = "tcp"
#   }

#   # droplet_tag = "node-pool-tag"

#   droplet_ids = [digitalocean_kubernetes_cluster.kube_cluster.node_pool[0].nodes[0].droplet_id]

# }

output "cluster-id" {
  value = digitalocean_kubernetes_cluster.kube_cluster.id
}

# output "lb-ip" {
#   value = digitalocean_loadbalancer.ingress.ip
# }
