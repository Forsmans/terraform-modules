/**
  * # Falco
  *
  * Adds [`Falco`](https://github.com/falcosecurity/falco) to a Kubernetes clusters.
  * The modules consists of two components, the main Falco driver and the sidekick which
  * exports events to Datadog.
  */

terraform {
  required_version = "0.14.7"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.0.3"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.1.0"
    }
  }
}

locals {
  falco_values = templatefile("${path.module}/templates/falco-values.yaml.tpl", {})
  falcosidekick_values = templatefile("${path.module}/templates/falcosidekick-values.yaml.tpl", {
    environment      = var.environment
    minimum_priority = var.minimum_priority
    datadog_host     = "https://${var.datadog_site}"
    datadog_api_key  = var.datadog_api_key
  })
}

resource "kubernetes_namespace" "this" {
  metadata {
    labels = {
      name = "falco"
    }
    name = "falco"
  }
}

resource "helm_release" "falco" {
  repository = "https://falcosecurity.github.io/charts"
  chart      = "falco"
  name       = "falco"
  namespace  = kubernetes_namespace.this.metadata[0].name
  version    = "1.8.0"
  values     = [local.falco_values]
}

resource "helm_release" "falcosidekick" {
  repository = "https://falcosecurity.github.io/charts"
  chart      = "falcosidekick"
  name       = "falcosidekick"
  namespace  = kubernetes_namespace.this.metadata[0].name
  version    = "0.3.0"
  values     = [local.falcosidekick_values]
}
