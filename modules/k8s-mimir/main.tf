variable "chart_version" {
  description = "Version of the mimir-distributed Helm Chart to install."
  type        = string
}

variable "namespace" {
  description = "Namespace to install Mimir in."
  type        = string
  default     = "mimir"
}

resource "helm_release" "this" {
  name             = "mimir"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "mimir-distributed"
  version          = var.chart_version
  namespace        = var.namespace
  create_namespace = true

  values = [
    yamlencode({
      alertmanager = {
        persistentVolume = {
          enabled = false
        }
      }

      ingester = {
        persistentVolume = {
          enabled = false
        }

        replicas = 2

        zoneAwareReplication = {
          enabled     = false
          topologyKey = "kubernetes.io/hostname"
          zones = [
            {
              name = "zone-a"
              nodeSelector = {
                "topology.kubernetes.io/zone" = "hal-5"
              }
            },
            {
              name = "zone-b"
              nodeSelector = {
                "topology.kubernetes.io/zone" = "hal-8"
              }
            },
          ]
        }
      }

      store_gateway = {
        persistentVolume = {
          enabled = false
        }

        zoneAwareReplication = {
          enabled     = false
          topologyKey = "kubernetes.io/hostname"
          zones = [
            {
              name = "zone-a"
              nodeSelector = {
                "topology.kubernetes.io/zone" = "hal-5"
              }
            },
            {
              name = "zone-b"
              nodeSelector = {
                "topology.kubernetes.io/zone" = "hal-8"
              }
            },
          ]
        }
      }

      compactor = {
        persistentVolume = {
          enabled = false
        }
      }

      nginx = {
        enabled = false
      }

      gateway = {
        enabledNonEnterprise = true
      }

      minio = {
        enabled = true

        persistence = {
          enabled = false
        }
      }

      "mimir.structuredConfig" = <<-EOF
        common:
          storage:
            backend: filesystem
      EOF
    })
  ]
}

output "push_endpoint" {
  value = "http://loki-loki-distributed-gateway.${var.namespace}.svc.cluster.local/api/v1/push"
}
