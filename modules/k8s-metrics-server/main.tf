variable "chart_version" {
  description = "Version of the Metrics Server Helm Chart to install."
  type        = string
}

variable "namespace" {
  description = "Namespace to install the Metrics Server in."
  type        = string
  default     = "kube-system"
}

resource "helm_release" "this" {
  name             = "metrics-server"
  repository       = "https://kubernetes-sigs.github.io/metrics-server/"
  chart            = "metrics-server"
  version          = var.chart_version
  namespace        = var.namespace
  create_namespace = true

  values = [
    yamlencode({
      defaultArgs = [
        # From default values
        "--cert-dir=/tmp",
        "--kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname",
        "--kubelet-use-node-status-port",
        "--metric-resolution=15s",

        # Allows metrics-server to pull kubelet metrics
        "--kubelet-insecure-tls",
      ]
    })
  ]
}
