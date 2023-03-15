module "nginx_ingress" {
  source = "./../../modules/k8s-nginx-ingress"

  chart_version = "4.6.0"
  namespace     = "ingress-nginx"
}
