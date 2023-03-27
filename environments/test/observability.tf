module "kube_prometheus_stack" {
  source = "./../../modules/k8s-kube-prometheus-stack"

  chart_version = "45.7.1"
  namespace     = "kube-prometheus-stack"
}

module "grafana" {
  source = "./../../modules/k8s-grafana"

  chart_version = "6.52.4"
  namespace     = "grafana"
}

module "metrics_server" {
  source = "./../../modules/k8s-metrics-server"

  chart_version = "3.8.4"
  namespace     = "kube-system"
}

module "goldpinger" {
  source = "./../../modules/k8s-goldpinger"

  chart_version = "5.6.0"
}

module "promtail" {
  source = "./../../modules/k8s-promtail"

  chart_version = "6.9.3"
  namespace     = "promtail"

  push_endpoints = [
    module.loki.push_endpoint,
  ]
}

module "loki" {
  source = "./../../modules/k8s-loki"

  chart_version = "0.69.9"
  namespace     = "loki"
}
