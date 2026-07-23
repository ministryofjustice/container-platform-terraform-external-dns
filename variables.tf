variable "region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "eu-west-2"
}

variable "eks_cluster_name" {
  description = "cluster name passed from the main module to link the external dns helm release and pod identity to the correct cluster."
  type        = string
}

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

variable "policy" {
  description = "ExternalDNS synchronisation policy. 'upsert-only' creates/updates records but NEVER deletes them (records are retained when the source HTTPRoute/Service is removed); 'sync' keeps DNS fully in step with sources (deletes records when the source is removed); 'create-only' only ever creates records."
  type        = string
  default     = "upsert-only"

  validation {
    condition     = contains(["sync", "upsert-only", "create-only"], var.policy)
    error_message = "policy must be one of: sync, upsert-only, create-only."
  }
}

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
    condition     = contains(["HMPPS", "OPG", "LAA", "Central Digital", "Technology Services", "HMCTS", "CICA", "OCTO", "YJB"], lookup(var.tags, "business-unit", ""))
    error_message = "Allowed values for business-unit are: HMPPS, OPG, LAA, Central Digital, Technology Services, HMCTS, CICA, OCTO, YJB."
  }
}
