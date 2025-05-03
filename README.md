## Hello friends

This repo creates a vpc, ec2 jumpbox loaded with terraform, kubectl and eksctl, an s3 bucket to hold remote Terraform state and an interface gateway to privately reach it - all to be used as a dev environment for AWS platform engineering.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.7.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 5.21.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_vpc_endpoint.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [random_pet.this](https://registry.terraform.io/providers/hashicorp/random/3.7.2/docs/resources/pet) | resource |
| [aws_ami.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cidr"></a> [cidr](#input\_cidr) | RFC1918 CIDR block for the VPC. | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region the provider will be configured for | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_iam_policy"></a> [aws\_iam\_policy](#output\_aws\_iam\_policy) | The iam policy outputs. |
| <a name="output_aws_iam_role"></a> [aws\_iam\_role](#output\_aws\_iam\_role) | The iam role outputs. |
| <a name="output_aws_iam_role_policy_attachment"></a> [aws\_iam\_role\_policy\_attachment](#output\_aws\_iam\_role\_policy\_attachment) | The iam policy attachment outputs. |
| <a name="output_aws_instance"></a> [aws\_instance](#output\_aws\_instance) | The ec2 outputs. |
| <a name="output_aws_s3_bucket"></a> [aws\_s3\_bucket](#output\_aws\_s3\_bucket) | The s3 bucket outputs. |
| <a name="output_aws_vpc_endpoint"></a> [aws\_vpc\_endpoint](#output\_aws\_vpc\_endpoint) | The s3 vpc endpoint outputs. |
| <a name="output_random_pet"></a> [random\_pet](#output\_random\_pet) | This is the vpc name. |
| <a name="output_vpc"></a> [vpc](#output\_vpc) | All vpc module outputs. |
<!-- END_TF_DOCS -->