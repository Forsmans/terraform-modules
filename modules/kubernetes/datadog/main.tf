/**
  * # Datadog
  *
  * Adds [Datadog](https://github.com/DataDog/helm-charts) to a Kubernetes cluster.
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
  values = templatefile("${path.module}/templates/values.yaml.tpl", {
    datadog_site = var.datadog_site
    api_key      = var.api_key
    location     = var.location
    environment  = var.environment
  })
}

resource "kubernetes_namespace" "this" {
  metadata {
    labels = {
      name = "datadog"
    }
    name = "datadog"
  }
}

resource "helm_release" "datadog" {
  repository = "https://helm.datadoghq.com"
  chart      = "datadog"
  name       = "datadog"
  namespace  = kubernetes_namespace.this.metadata[0].name
  version    = "2.10.13"
  values     = [local.values]
}
