variable "chart_version" {
  description = "The version of external DNS to deploy."
  type        = string
  default     = "1.21.1"
}
variable "sync_interval" {
  description = "The interval at which external DNS syncs."
  type = object({
    development = string
    production  = string
  })
  default = {
    development = "10m"
    production  = "60m"
  }
}
variable "aws_zone_cache_duration" {
  description = "The duration for which AWS zone information is cached."
  type = object({
    development = string
    production  = string
  })
  default = {
    development = "2h"
    production  = "2h"
  }
}

variable "tags" {
  description = "A map of tags to apply to resources created by this module. Allowed keys are: application, business-unit, owner, service-area, source-code, slack-channel, is-production."
  type        = map(string)
  default = {
    application   = "External DNS"
    business-unit = "OCTO"
    owner         = "Container Platform: External DNS"
    service-area  = "Hosting"
    source-code   = "https://github.com/ministryofjustice/cloud-platform-external-dns"
    slack-channel = "cloud-platform"
    is-production = "true"
  }
}