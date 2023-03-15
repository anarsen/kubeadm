variable "chart_version" {
  description = "Version of the tigera-operator Helm Chart to install."
  type        = string
}

variable "namespace" {
  description = "Namespace to install the tigera-operator in."
  type        = string
  default     = "calico-operator"
}

resource "helm_release" "this" {
  name             = "calico-operator"
  repository       = "https://docs.tigera.io/calico/charts"
  chart            = "tigera-operator"
  version          = var.chart_version
  namespace        = var.namespace
  create_namespace = true

  values = [
    yamlencode({
      installation = {
        cni = {
          type = "Calico"
        }

        calicoNetwork = {
          bgp = "Disabled"
          ipPools = [
            {
              cidr          = "10.100.0.0/18"
              encapsulation = "VXLAN"
            },
          ]
        }
      }
    })
  ]
}
