# Module Usage

The below example demonstrates the basic usage of the module. The `required_inputs` variable is a map of maps, where the key is the Terraform workspace and the value is a map of the required input variables, that are passed into the helm template for deployment. This allows for different configurations for different environments (e.g. development, staging, production) using Terraform workspaces. The example also includes the `tags` variable, which can be used to apply tags to all resources created by the module. The required inputs and tags should be defined in your Terraform configuration when using the module, the requirements can be found in the [requirements](module-requirements.md) documentation.

```hcl 
module "external_dns" {
  source = "github.com/ministryofjustice/container-platform-terraform-external-dns?ref=<latest release version>"

  eks_cluster_name = <environment name>

  required_inputs = {
    <terraform workspace> = {
      domain_name_prefix      = <environment name>
      sync_interval           = <sync interval>
      aws_zone_cache_duration = <aws zone cache duration>
      log_level               = <log level>
    }
  }
  tags = <tags>
}
```

The below example demonstrates how to use the module with different configurations for different Terraform workspaces. Each workspace (e.g. development, preproduction, nonlive, live) has its own set of required input variables, allowing for environment-specific configurations. The `tags` variable is also included to apply tags to all resources created by the module.

```hcl
module "external_dns" {
  source = "github.com/ministryofjustice/container-platform-terraform-external-dns?ref=v0.1.0"

  eks_cluster_name = local.environment_name

  required_inputs = {
    cloud-platform-development = {
      domain_name_prefix      = "development"
      sync_interval           = "10m"
      aws_zone_cache_duration = "2h"
      log_level               = "debug"
    }
    cloud-platform-preproduction = {
      domain_name_prefix      = "preproduction"
      sync_interval           = "10m"
      aws_zone_cache_duration = "2h"
      log_level               = "info"
    }
    cloud-platform-nonlive = {
      domain_name_prefix      = "nonlive"
      sync_interval           = "60m"
      aws_zone_cache_duration = "2h"
      log_level               = "info"
    }
    cloud-platform-live = {
      domain_name_prefix      = "live"
      sync_interval           = "60m"
      aws_zone_cache_duration = "2h"
      log_level               = "info"
    }
  }
  tags = {
    application   = "External DNS"
    business-unit = "OCTO"
    owner         = "Container Platform: External DNS"
    service-area  = "Hosting"
    source-code   = "https://github.com/ministryofjustice/cloud-platform-external-dns"
    slack-channel = "cloud-platform"
    is-production = "true"
  }
}
```

## Optional: `policy`

The optional `policy` variable controls how ExternalDNS reconciles Route 53 records. It defaults to `sync`, which keeps DNS fully in step with sources, deleting a record when its source `HTTPRoute`/`Service` is removed. Set it to `upsert-only` to create and update records but **never delete** them, so a record is retained when its source is removed, or `create-only` to only ever create records.

```hcl
module "external_dns" {
  source = "github.com/ministryofjustice/container-platform-terraform-external-dns?ref=<latest release version>"

  eks_cluster_name = local.environment_name
  policy           = "upsert-only" # one of: sync (default), upsert-only, create-only

  required_inputs = {
    # ...
  }
  tags = <tags>
}
```

> Note: the default remains `sync`, matching the previous behaviour, so this variable is additive. Set `policy = "upsert-only"` only if you want records to be retained when their source is removed.
