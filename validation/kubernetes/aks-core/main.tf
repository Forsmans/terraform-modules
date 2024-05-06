terraform {}

provider "azurerm" {
  features {}
}

module "aks_core" {
  source = "../../../modules/kubernetes/aks-core"

  name                    = "baz"
  aks_managed_identity    = "id"
  aks_name_suffix         = 1
  core_name               = "core"
  dns_zones               = ["a.com"]
  location_short          = "foo"
  global_location_short   = "sc"
  environment             = "bar"
  subscription_id         = "id"
  subscription_name       = "baz"
  group_name_prefix       = "aks"
  namespaces              = []
  aad_pod_identity_config = {}
  velero_config = {
    azure_storage_account_name      = "foo"
    azure_storage_account_container = "bar"
    identity = {
      client_id   = ""
      resource_id = ""
    }
  }
  cert_manager_config = {
    notification_email = "foo"
    dns_zone           = ["bar", "faa"]
  }
  fluxcd_v2_config = {
    type = "github"
    github = {
      org             = ""
      app_id          = 0
      installation_id = 0
      private_key     = ""
    }
    azure_devops = {
      pat  = ""
      org  = ""
      proj = ""
    }
  }

  priority_expander_config = { "10" : [".*standard.*"], "20" : [".*spot.*"] }

  aad_groups = {
    view = {
      test = {
        id   = "id"
        name = "name"
      }
    }
    edit = {
      test = {
        id   = "id"
        name = "name"
      }
    }
    cluster_admin = {
      id   = "id"
      name = "name"
    }
    cluster_view = {
      id   = "id"
      name = "name"
    }
    aks_managed_identity = {
      id   = "id"
      name = "name"
    }
  }

  trivy_enabled = true
  trivy_config = {
    client_id   = "foo"
    resource_id = "bar"
  }

  ingress_nginx_config = {
    public_private_enabled = false
  }

  prometheus_enabled = true
  prometheus_config = {
    azure_key_vault_name = "foobar"
    identity = {
      client_id   = ""
      resource_id = ""
      tenant_id   = ""
    }

    tenant_id = ""

    remote_write_authenticated = true
    remote_write_url           = "https://my-receiver.com"

    volume_claim_storage_class_name = "default"
    volume_claim_size               = "5Gi"

    resource_selector  = ["platform"]
    namespace_selector = ["platform"]
  }
  external_dns_hostname = "foobar.com"
}
