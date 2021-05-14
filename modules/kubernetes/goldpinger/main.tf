/**
  * # Goldpinger
  *
  * Adds [`Goldpinger`](https://github.com/bloomberg/goldpinger) to a Kubernetes clusters.
  */

terraform {
  required_version = "0.14.7"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.1.2"
    }
  }
}

resource "kubernetes_namespace" "this" {
  metadata {
    labels = {
      name                = "goldpinger"
      "xkf.xenit.io/kind" = "platform"
    }
    name = "goldpinger"
  }
}

# Official Helm repo is deprecated to using fork.
# https://github.com/bloomberg/goldpinger/issues/93
resource "helm_release" "goldpinger" {
  repository = "https://okgolove.github.io/helm-charts/"
  chart      = "goldpinger"
  name       = "goldpinger"
  namespace  = kubernetes_namespace.this.metadata[0].name
  version    = "4.1.1"
  values = [templatefile("${path.module}/templates/values.yaml.tpl", {
    linkerd_enabled = var.linkerd_enabled
  })]
}
