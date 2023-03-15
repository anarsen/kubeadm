variable "chart_version" {
  description = "Version of the Goldpinger Helm Chart to install."
  type        = string
}

variable "namespace" {
  description = "Namespace to install the Goldpinger erver in."
  type        = string
  default     = "goldpinger"
}

resource "helm_release" "this" {
  name             = "goldpinger"
  repository       = "https://okgolove.github.io/helm-charts/"
  chart            = "goldpinger"
  version          = var.chart_version
  namespace        = var.namespace
  create_namespace = true

  values = [
    yamlencode({
      service = {
        type = "ClusterIP"
      }

      serviceMonitor = {
        enabled = true
      }

      prometheusRule = {
        enabled = true
      }

      tolerations = [
        {
          key      = "node-role.kubernetes.io/control-plane"
          effect   = "NoSchedule"
          operator = "Exists"
        },
        {
          key      = "node-role.kubernetes.io/master"
          effect   = "NoSchedule"
          operator = "Exists"
        },
      ]
    })
  ]
}
