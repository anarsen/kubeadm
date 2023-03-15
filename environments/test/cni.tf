module "calico_operator" {
  source = "./../../modules/k8s-calico"

  chart_version = "v3.25.0"
  namespace     = "calico-operator"
}
