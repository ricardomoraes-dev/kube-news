terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

resource "local_file" "kube_config" {
  content = digitalocean_kubernetes_cluster.k8s_kubenews.kube_config.0.raw_config
  filename = "kube_config.yaml"
}

resource "digitalocean_kubernetes_cluster" "k8s_kubenews" {
  name   = var.k8s_name
  region = var.k8s_region
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = "1.22.12-do.0"

  node_pool {
    name       = "default"
    size       = "s-2vcpu-2gb"
    node_count = 3
  }
}

variable "do_token" {}
variable "k8s_name" {}
variable "k8s_region" {}

output "kube_endpoint" {
  value = digitalocean_kubernetes_cluster.k8s_kubenews.endpoint

}