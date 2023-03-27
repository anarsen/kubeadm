variable "chart_version" {
  description = "Version of the Promtail Helm Chart to install."
  type        = string
}

variable "namespace" {
  description = "Namespace to install Promtail in."
  type        = string
  default     = "promtail"
}

variable "push_endpoints" {
  description = "List of endpoints to push logs to."
  type        = list(string)
}

resource "helm_release" "this" {
  name             = "promtail"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "promtail"
  version          = var.chart_version
  namespace        = var.namespace
  create_namespace = true

  values = [
    yamlencode({
      serviceMonitor = {
        enabled = true

        prometheusRule = {
          enabled = false
        }
      }

      config = {
        clients = [
          for endpoint in var.push_endpoints : {
            url = endpoint
          }
        ]
      }
    })
  ]
}
