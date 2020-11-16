resource "helm_release" "gatekeeper" {
  repository = "https://open-policy-agent.github.io/gatekeeper/charts"
  chart      = "gatekeeper"
  name       = "gatekeeper"
  version    = "v3.2.0"
}

resource "helm_release" "gatekeeper_templates" {
  depends_on = [helm_release.gatekeeper]

  repository = "https://xenitab.github.io/gatekeeper-library/"
  chart      = "gatekeeper-library-templates"
  name       = "gatekeeper-library-templates"
  version    = "v0.4.0"
  values = [templatefile("templates/gatekeeper-library-values.yaml.tpl")]
}

resource "helm_release" "gatekeeper_constraints" {
  depends_on = [helm_release.gatekeeper, helm_release.gatekeeper_templates]

  repository = "https://xenitab.github.io/gatekeeper-library/"
  chart      = "gatekeeper-library-constraints"
  name       = "gatekeeper-library-constraints"
  version    = "v0.4.0"
  values = [templatefile("templates/gatekeeper-library-values.yaml.tpl")]
}
