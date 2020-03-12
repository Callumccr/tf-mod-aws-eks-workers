## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.0 >= 2.7.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| ami\_release\_version | (Optional) - AMI version of the EKS Node Group. Defaults to latest version for Kubernetes version | `string` | n/a | yes |
| cluster\_name | (Required) - The name of the EKS cluster | `string` | n/a | yes |
| desired\_size | (Required) - Desired number of worker nodes | `number` | n/a | yes |
| ec2\_ssh\_key | (Optional) - SSH key name that should be used to access the worker nodes | `string` | n/a | yes |
| instance\_types | (Required) - Set of instance types associated with the EKS Node Group. Defaults to ["t3.medium"]. Terraform will only perform drift detection if a configuration value is provided | `list(string)` | n/a | yes |
| kubernetes\_version | (Optional) - Kubernetes version. Defaults to EKS Cluster Kubernetes version. Terraform will only perform drift detection if a configuration value is provided | `string` | n/a | yes |
| max\_size | (Required) - Maximum number of worker nodes | `number` | n/a | yes |
| min\_size | (Required) - Minimum number of worker nodes | `number` | n/a | yes |
| subnet\_ids | (Required) - A list of subnet IDs to launch resources in | `list(string)` | n/a | yes |
| additional\_security\_group\_ids | (Optional) - Allow inbound traffic from existing Security Groups | `list(string)` | `[]` | no |
| allowed\_cidrs | (Optional) - List of CIDR blocks which can access the Amazon EKS workers | `list(string)` | <code><pre>[<br>  ""<br>]<br></pre></code> | no |
| ami\_type | (Optional) - Type of Amazon Machine Image (AMI) associated with the EKS Node Group. Defaults to `AL2_x86_64`. Valid values: `AL2_x86_64`, `AL2_x86_64_GPU`. Terraform will only perform drift detection if a configuration value is provided | `string` | `"AL2_x86_64"` | no |
| attributes | (Optional) - Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| aws\_account\_id | The AWS account id of the provider being deployed to (e.g. 12345678). Autoloaded from account.tfvars | `string` | `""` | no |
| aws\_assume\_role\_arn | (Optional) - ARN of the IAM role when optionally connecting to AWS via assumed role. Autoloaded from account.tfvars. | `string` | `""` | no |
| aws\_assume\_role\_external\_id | (Optional) - The external ID to use when making the AssumeRole call. | `string` | `""` | no |
| aws\_assume\_role\_session\_name | (Optional) - The session name to use when making the AssumeRole call. | `string` | `""` | no |
| aws\_region | The AWS region (e.g. ap-southeast-2). Autoloaded from region.tfvars. | `string` | `""` | no |
| delimiter | (Optional) - Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes` | `string` | `"-"` | no |
| disk\_size | (Optional) - Disk size in GiB for worker nodes. Defaults to 20. Terraform will only perform drift detection if a configuration value is provided | `number` | `20` | no |
| enable\_cluster\_autoscaler | (Optional) - Whether to enable node group to scale the Auto Scaling Group | `bool` | `false` | no |
| enabled | (Optional) - Whether to create the resources. Set to `false` to prevent the module from creating any resources | `bool` | `true` | no |
| environment | (Optional) - Environment, e.g. 'dev', 'qa', 'staging', 'prod' | `string` | `""` | no |
| existing\_workers\_role\_policy\_arns | (Optional) - List of existing policy ARNs that will be attached to the workers default role on creation | `list(string)` | `[]` | no |
| existing\_workers\_role\_policy\_arns\_count | (Optional) - Count of existing policy ARNs that will be attached to the workers default role on creation. Needed to prevent Terraform error `count can't be computed` | `number` | `0` | no |
| kubernetes\_labels | (Optional) - Key-value mapping of Kubernetes labels. Only labels that are applied with the EKS API are managed by this argument. Other Kubernetes labels applied to the EKS Node Group will not be managed | `map(string)` | `{}` | no |
| name | (Optional) - Solution name, e.g. 'vault', 'consul', 'keycloak', 'k8s', or 'baseline' | `string` | `""` | no |
| namespace | (Optional) - Namespace, which could be your abbreviated product team, e.g. 'rci', 'mi', 'hp', or 'core' | `string` | `""` | no |
| source\_security\_group\_ids | (Optional) - Set of EC2 Security Group IDs to allow SSH access (port 22) from on the worker nodes. If you specify `ec2_ssh_key`, but do not specify this configuration when you create an EKS Node Group, port 22 on the worker nodes is opened to the Internet (0.0.0.0/0) | `list(string)` | `[]` | no |
| tags | (Optional) - Additional tags | `map(string)` | `{}` | no |
| use\_existing\_security\_group | (Optional) - Whether to create a security group for the workers or use an existing | `boolean` | `false` | no |
| vpc\_id | (Optional) - VPC ID for the EKS workers | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| eks\_node\_group\_arn | Amazon Resource Name (ARN) of the EKS Node Group |
| eks\_node\_group\_id | EKS Cluster name and EKS Node Group name separated by a colon |
| eks\_node\_group\_resources | List of objects containing information about underlying resources of the EKS Node Group |
| eks\_node\_group\_role\_arn | ARN of the worker nodes IAM role |
| eks\_node\_group\_role\_name | Name of the worker nodes IAM role |
| eks\_node\_group\_status | Status of the EKS Node Group |

