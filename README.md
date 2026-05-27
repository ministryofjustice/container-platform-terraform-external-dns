# Container Platform Terraform External DNS Module

[![Ministry of Justice Repository Compliance Badge](https://github-community.service.justice.gov.uk/repository-standards/api/container-platform-terraform-external-dns/badge)](https://github-community.service.justice.gov.uk/repository-standards/container-platform-terraform-external-dns)


## Usage
This repository is intended to be used as a Terraform module for deploying External DNS on EKS clusters. It includes resources for setting up the necessary Pod Identity and Helm release for External DNS. To use this module, include it in your Terraform configuration and provide the required input variables.

Complete usage of the module can be found in the [examples](./examples) directory, with the documentation for usage provided in the wiki [here](./wiki/module-usage.md).

## Structure

```
├── main.tf           # Main module resources
├── variables.tf      # Input variables
├── data.tf           # Data sources
├── pod_identity.tf   # Pod identity resources
├── outputs.tf        # Output values
├── locals.tf         # Local values
├── templates/        # Directory for Helm chart templates
├── examples/         # Directory for example usage of the module
├── versions.tf       # Provider and Terraform version constraints
└── README.md
```

## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 1.0 |

## Repository Standards

This repository follows the [Ministry of Justice GitHub Repository Standards](https://github-community.service.justice.gov.uk/repository-standards/guidance).

## License

[MIT License](LICENSE)
