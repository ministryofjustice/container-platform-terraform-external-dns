module "external_dns" {
  source = "../"

  eks_cluster_name = local.environment_name

  required_inputs = {
    cloud-platform-development = {
      version                 = var.chart_version
      domain_name_prefix      = "development"
      sync_interval           = var.sync_interval.development
      aws_zone_cache_duration = var.aws_zone_cache_duration.development
      log_level               = "info"
    }
    cloud-platform-preproduction = {
      version                 = var.chart_version
      domain_name_prefix      = "preproduction"
      sync_interval           = var.sync_interval.development
      aws_zone_cache_duration = var.aws_zone_cache_duration.development
      log_level               = "info"
    }
    cloud-platform-nonlive = {
      version                 = var.chart_version
      domain_name_prefix      = "nonlive"
      sync_interval           = var.sync_interval.production
      aws_zone_cache_duration = var.aws_zone_cache_duration.production
      log_level               = "info"
    }
    cloud-platform-live = {
      version                 = var.chart_version
      domain_name_prefix      = "live"
      sync_interval           = var.sync_interval.production
      aws_zone_cache_duration = var.aws_zone_cache_duration.production
      log_level               = "info"
    }
  }
  tags = var.tags
}