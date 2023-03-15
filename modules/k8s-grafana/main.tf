variable "chart_version" {
  description = "Version of the Grafana Helm Chart to install."
  type        = string
}

variable "namespace" {
  description = "Namespace to install Grafana in."
  type        = string
  default     = "grafana"
}

resource "helm_release" "this" {
  name             = "grafana"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  version          = var.chart_version
  namespace        = var.namespace
  create_namespace = true

  values = [
    yamlencode({
      serviceMonitor = {
        enabled = true
      }

      ingress = {
        enabled          = true
        ingressClassName = "nginx"

        hosts = [
          "grafana.platform.mvno.dk",
        ]
      }

      sidecar = {
        dashboards = {
          enabled = true

          searchNamespace = "ALL"
        }

        datasources = {
          enabled = true

          searchNamespace = "ALL"
        }

        plugins = {
          enabled = true

          searchNamespace = "ALL"
        }

        notifiers = {
          enabled = true

          searchNamespace = "ALL"
        }
      }

      "grafana.ini" = {
        "auth.azuread" = {
          enabled       = true
          name          = "Azure AD"
          allow_signup  = true
          client_id     = module.oidc_client.client_id
          client_secret = module.oidc_client.client_secret
          scopes        = "openid email profile"
          auth_url      = module.oidc_client.authorize_url
          token_url     = module.oidc_client.token_url
        }
      }
    })
  ]
}

module "oidc_client" {
  source = "/home/anders/platform/modules/oidc-client"

  name = "grafana-k8s"

  redirect_uris = [
    "https://grafana.platform.mvno.dk/login/generic_oauth",
    "https://grafana.platform.mvno.dk/login/azuread",
    "http://localhost:3000/login/azuread",
  ]

  roles = [
    {
      name            = "Admin"
      display_name    = "Grafana Administrator"
      description     = "Grants Grafana Administrator permissions"
      allow_for_users = true
    },

    {
      name            = "GrafanaAdmin"
      display_name    = "Grafana Server Administrator"
      description     = "Grants Grafana Server Administrator permissions"
      allow_for_users = true
    },
  ]
}
