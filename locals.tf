locals {
  # if terraform.workspace in var.required_inputs.terraform workspaces then use the config for that workspace, otherwise use the config for cloud-platform-development
  workspace_config = contains(keys(var.required_inputs), terraform.workspace) ? var.required_inputs[terraform.workspace] : var.required_inputs["cloud-platform-development"]

  namespace   = "external-dns"
  # base_domain = "container-platform.service.justice.gov.uk"
  base_domain = "cloud-platform.service.justice.gov.uk"
}
