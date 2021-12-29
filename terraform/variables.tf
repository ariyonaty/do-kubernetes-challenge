variable "do_token" {
  description = "DigitalOcean API Token"
}

variable "private_key" {
  description = "SSH private key for provisioning instance"
  default     = "../ssh/do_key"
}

variable "cluster_name" {
  description = "Name of k8s cluster"
  default     = "do-kubernetes-challenge"
}

variable "pool_name" {
  description = "Name of k8s pool"
  default     = "worker-pool"
}

variable "region" {
  description = "DigitalOcean region"
  default     = "sfo3"
}

variable "kube_version" {
  description = "Version of Kubernetes"
  default     = "1.19.15-do.0"
}

variable "slug_size" {
  description = "Size of slug/node"
  default     = "s-1vcpu-2gb"
}

variable "node_count" {
  description = "Number of nodes in cluster"
  default     = "2"
}
