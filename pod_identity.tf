module "aws_external_dns_pod_identity" {
  source  = "terraform-aws-modules/eks-pod-identity/aws"
  version = "2.8.1"

  name = "aws-external-dns"

  attach_external_dns_policy    = true
  external_dns_hosted_zone_arns = [data.aws_route53_zone.external_dns_zone.arn]

  associations = {
    this = {
      cluster_name    = var.eks_cluster_name
      namespace       = "external-dns"
      service_account = "external-dns-sa"
    }
  }

  tags = var.tags
}