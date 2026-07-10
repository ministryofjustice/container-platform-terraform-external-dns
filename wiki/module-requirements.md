# Module Requirements

This is a list of the requirements for using the External DNS Terraform module. These requirements must be met in order to successfully deploy External DNS on your EKS cluster using this module.

## Variables

The variables in this module are validated to ensure that all requirements are met before applying the Terraform configuration. 

### required_inputs

The `required_inputs` variable is a map of maps, where the key is the Terraform workspace and the value is a map of the required input variables for that workspace. Each required input variable is validated to ensure that it is not empty, and that all required fields are provided for each workspace configuration. The required input variables for each workspace include:
- `domain_name_prefix`: The prefix for the domain name to be used by External DNS.
- `sync_interval`: The interval at which External DNS will sync with the DNS provider.
- `aws_zone_cache_duration`: The duration for which AWS zone information will be cached by External DNS.
- `log_level`: The log level for External DNS (e.g. debug, info, warn, error).

if the `required_inputs` variable is not provided for a specific workspace, the plan will fail with an error message indicating that the required inputs for that workspace are missing. This ensures that all necessary configurations are provided for each environment before deployment.

```hcl
variable "required_inputs" {
  description = "The inputs for the external DNS module for each workspace. If terraform.workspace starts with 'cp-' the config for that workspace will be used, otherwise the config for 'cloud-platform-development' will be used."
  type = map(
    object({
      domain_name_prefix      = string
      sync_interval           = string
      aws_zone_cache_duration = string
      log_level               = string
    })
  )
  validation {
    condition = alltrue([
      for config in values(var.required_inputs) :
      alltrue([
        for value in [
          config.domain_name_prefix,
          config.sync_interval,
          config.aws_zone_cache_duration,
          config.log_level
        ] : trimspace(value) != ""
      ])
    ])
    error_message = "Each required_inputs entry must include non-empty values for domain_name_prefix, sync_interval, aws_zone_cache_duration, and log_level."
  }
}
```

### tags
The `tags` variable is a map of tags to apply to resources created by this module. It includes validation to ensure that all required tag keys are present and have non-empty values. The allowed keys for the `tags` variable are: 
- application, 
- business-unit, 
- owner, 
- service-area, 
- source-code, 
- slack-channel, 
- is-production. 

Additionally, the `business-unit` tag is validated against a list of allowed values (HMPPS, OPG, LAA, Central Digital, Technology Services, HMCTS, CICA, OCTO, YJB) to ensure consistency in tagging across resources. If any of the required tags are missing or have empty values, or if the `business-unit` tag has an invalid value, the plan will fail with an appropriate error message. This ensures that all resources created by the module are properly tagged for identification and management purposes.

```hcl
variable "tags" {
  description = "A map of tags to apply to resources created by this module. Allowed keys are: application, business-unit, owner, service-area, source-code, slack-channel, is-production."
  type        = map(string)
  default = {
    application   = "External DNS"
    business-unit = "OCTO"
    owner         = "Container Platform: platforms@digital.justice.gov.uk"
    service-area  = "Hosting"
    source-code   = "https://github.com/ministryofjustice/container-platform-external-dns"
    slack-channel = "cloud-platform"
    is-production = "true"
  }

  validation {
    condition = alltrue([
      for key in [
        "application",
        "business-unit",
        "owner",
        "service-area",
        "source-code",
        "slack-channel",
        "is-production"
      ] : contains(keys(var.tags), key) && trimspace(var.tags[key]) != ""
    ])
    error_message = "Each tags entry must include non-empty values for application, business-unit, owner, service-area, source-code, slack-channel, and is-production."
  }

  validation {
    condition = contains(["HMPPS", "OPG", "LAA", "Central Digital", "Technology Services", "HMCTS", "CICA", "OCTO", "YJB"], lookup(var.tags, "business-unit", ""))
    error_message = "Allowed values for business-unit are: HMPPS, OPG, LAA, Central Digital, Technology Services, HMCTS, CICA, OCTO, YJB."
  }
}
```