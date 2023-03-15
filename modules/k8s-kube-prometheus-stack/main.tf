variable "chart_version" {
  description = "Version of the Ingress NGINX chart to install."
  type        = string
}

variable "namespace" {
  description = "Namespace to install NGINX ingress controller in."
  type        = string
}

resource "helm_release" "this" {
  name             = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = var.chart_version
  namespace        = var.namespace
  create_namespace = true

  values = [
    yamlencode({
      grafana = {
        # We install Grafana with a dedicated Chart
        enabled = false

        forceDeployDatasources = true
        forceDeployDashboards  = true
      }

      prometheus = {
        prometheusSpec = {
          # Discover *all* ServiceMonitor and PodMonitor resources.
          # If true, then ServiceMonitors with same `release` label as
          # the Prom Operator will be discovered.
          serviceMonitorSelectorNilUsesHelmValues = false
          podMonitorSelectorNilUsesHelmValues     = false
        }
      }
    })
  ]
}
