variable "environment" {
  type        = string
  description = "Environment ingress-healthz is deployed in"
}

variable "dns_zone" {
  type        = string
  description = "DNS Zone to create ingress sub domain under"
}
