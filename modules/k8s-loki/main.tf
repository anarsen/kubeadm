variable "chart_version" {
  description = "Version of the loki-distributed Helm Chart to install."
  type        = string
}

variable "namespace" {
  description = "Namespace to install Loki in."
  type        = string
  default     = "loki"
}

resource "helm_release" "this" {
  name             = "loki"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "loki-distributed"
  version          = var.chart_version
  namespace        = var.namespace
  create_namespace = true

  values = [
    # PrometheusRules are terrible to express in HCL
    file("${path.module}/values-monitoring.yaml"),

    yamlencode({
      serviceMonitor = {
        enabled = true
      }

      prometheusRule = {
        enabled = true
      }
    })
  ]
}

output "push_endpoint" {
  value = "http://loki-loki-distributed-gateway.${var.namespace}.svc.cluster.local/loki/api/v1/push"
}
