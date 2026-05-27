# data to get hosted zone arn
data "aws_route53_zone" "external_dns_zone" {
  name         = "${local.workspace_config.domain_name_prefix}.${local.base_domain}"
  private_zone = false
}