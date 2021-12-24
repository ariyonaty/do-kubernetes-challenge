variable "do_token" {
  description = "DigitalOcean API Token"
}

variable "private_key" {
  description = "SSH private key for provisioning instance"
  default     = "../ssh/do_key"
}

variable "region" {
  description = "DigitalOcean region"
  default     = "sfo3"
}

variable "kube_version" {
  description = "Version of Kubernetes"
  default     = "1.21.5-do.0"
}

variable "slug_size" {
  description = "Size of slug/node"
  default     = "s-1vcpu-2gb"
}
