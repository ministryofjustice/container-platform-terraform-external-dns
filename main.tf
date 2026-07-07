resource "kubernetes_namespace_v1" "external_dns" {
  metadata {
    name = local.namespace

    labels = {
      "name"                                            = local.namespace
      "container-platform.justice.gov.uk/is-production" = var.tags["is-production"]
      "pod-security.kubernetes.io/enforce"              = "restricted"
    }

    annotations = {
      "container-platform.justice.gov.uk/application"           = var.tags["application"]
      "container-platform.justice.gov.uk/business-unit"         = var.tags["business-unit"]
      "container-platform.justice.gov.uk/owner"                 = var.tags["owner"]
      "container-platform.service.justice.gov.uk/service-area"  = var.tags["service-area"]
      "container-platform.justice.gov.uk/source-code"           = var.tags["source-code"]
      "container-platform.justice.gov.uk/slack-channel"         = var.tags["slack-channel"]
      "container-platform.service.justice.gov.uk/is-production" = var.tags["is-production"]
    }
  }
}

resource "time_sleep" "wait_for_pod_identity_association" {
  depends_on = [module.aws_external_dns_pod_identity]

  # EKS Pod Identity association can take a short time to propagate to admission.
  create_duration = "30s"
}

resource "helm_release" "external_dns" {
  name       = local.namespace
  chart      = local.namespace
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  version    = "1.21.1"
  namespace  = local.namespace

  values = [templatefile("${path.module}/templates/values.yaml.tpl", {
    domainFilters           = ["${local.workspace_config.domain_name_prefix}.${local.base_domain}"]
    sync_interval           = local.workspace_config.sync_interval
    aws_zone_cache_duration = local.workspace_config.aws_zone_cache_duration
    cluster                 = var.eks_cluster_name
    txtPrefix               = "_external_dns.%%{record_type}."
    loglevel                = local.workspace_config.log_level == "" ? "info" : local.workspace_config.log_level
  })]

  set = [
    {
      name  = "resources.requests.cpu"
      value = "200m"
    },
    {
      name  = "resources.requests.memory"
      value = "1024Mi"
    }
  ]

  depends_on = [
    kubernetes_namespace_v1.external_dns,
    time_sleep.wait_for_pod_identity_association
  ]
}