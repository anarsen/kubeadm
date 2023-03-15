variable "chart_version" {
  description = "Version of the Ingress NGINX chart to install."
  type        = string
}

variable "namespace" {
  description = "Namespace to install NGINX ingress controller in."
  type        = string
}

variable "node_port_http" {
  description = "Node port to allocate for the Service serving HTTP traffic."
  type        = number
  default     = 32080
}

variable "node_port_https" {
  description = "Node port to allocate for the Service serving HTTPS traffic."
  type        = number
  default     = 32443
}

resource "helm_release" "this" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = var.chart_version
  namespace        = var.namespace
  create_namespace = true

  wait = false

  values = [
    yamlencode({
      controller = {
        service = {
          type = "NodePort"
          nodePorts = {
            http  = var.node_port_http
            https = var.node_port_https
          }
        }

        metrics = {
          enabled = true
          port    = 10254

          serviceMonitor = {
            enabled = true
          }
        }

        ingressClassResource = {
          default = true
        }

        watchIngressWithoutClass = true

        publishService = {
          enabled = false
        }

        extraArgs = {
          "publish-status-address" = "internal-ingress.platform.mvno.dk"
          "update-status"          = true
        }
      }

      defaultBackend = {
        enabled = true
      }
    })
  ]
}
