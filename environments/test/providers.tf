provider "kubernetes" {
  # read from env
}

provider "helm" {
  kubernetes {
    config_path = "~/tmp/kubeadm/environments/test/admin.yaml"
  }
}

