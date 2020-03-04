<!-- 














  ** DO NOT EDIT THIS FILE
  ** 
  ** This file was automatically generated by the `build-harness`. 
  ** 1) Make all changes to `README.yaml` 
  ** 2) Run `make init` (you only need to do this once)
  ** 3) Run`make readme` to rebuild this file. 
  **
  ** (We maintain HUNDREDS of open source projects. This is how we maintain our sanity.)
  **















  -->

#

[![README Header][logo]][website]

# tf-mod-aws-eks-workers

## Module description


A Terraform module to provision & add EKS workers to a cluster




Project: **[%!s(<nil>)](%!s(<nil>))** : [[%!s(<nil>)](%!s(<nil>))] | [[%!s(<nil>)](%!s(<nil>))] 




## Introduction

The module provisions the following resources:
  - An EKS Node Group
  - A Supporting IAM Role with all the EKS workers policies required
  - (Optional) - A default security group to associate with the workers and the EKS cluster
  - (Optional) - Associates the required permissions and tags for the k8s cluster-autoscaler



## Usage

**IMPORTANT:** The `master` branch is used in `source` just as an example. In your code, do not pin to `master` because there may be breaking changes between releases.
Instead pin to the release tag (e.g. `?ref=tags/x.y.z`) of one of our [latest releases](https://github.com/https://github.com/Callumccr/tf-mod-aws-eks-workers/releases).


The below values shown in the usage of this module are purely representative, please replace desired values as required.

```hcl
  module "tf-mod-aws-eks-workers" {
    source                = "git::https://github.com/Callumccr/tf-mod-aws-eks-workers.git?ref=master
    namespace                 = var.namespace
    stage                     = var.stage
    name                      = var.name
    attributes                = var.attributes
    tags                      = var.tags
    vpc_id                    = var.vpc_id
    subnet_ids                = var.subnet_ids
    instance_types            = var.instance_types
    desired_size              = var.desired_size
    min_size                  = var.min_size
    max_size                  = var.max_size
    cluster_name              = var.cluster_name
    kubernetes_version        = var.kubernetes_version
  }
```





## Examples
### Advanced Example 1

The following example generates consistent names and tags for resources, a network stack, and a EKS cluster with workers.

```hcl
  module "tf-mod-label" {
    source     = "git::https://github.com/Callumccr/tf-mod-label.git?ref=master
    namespace  = var.namespace
    name       = var.name
    stage      = var.stage
    delimiter  = var.delimiter
    attributes = compact(concat(var.attributes, list("cluster")))
    tags       = var.tags
  }

  locals {
    tags = merge(module.label.tags, map("kubernetes.io/cluster/${module.label.id}", "shared"))
  }

  module "tf-mod-aws-vpc" {
    source     = "git::https://github.com/Callumccr/tf-mod-aws-vpc.git?ref=master
    namespace  = var.namespace
    stage      = var.stage
    name       = var.name
    attributes = var.attributes
    cidr_block = var.vpc_cidr_block
    tags       = local.tags
  }

  module "tf-mod-aws-subnets" {
    source               = "git::https://github.com/Callumccr/tf-mod-aws-subnets.git?ref=master
    availability_zones   = var.availability_zones
    namespace            = var.namespace
    stage                = var.stage
    name                 = var.name
    attributes           = var.attributes
    vpc_id               = module.vpc.vpc_id
    igw_id               = module.vpc.igw_id
    cidr_block           = module.vpc.vpc_cidr_block
    nat_gateway_enabled  = false
    nat_instance_enabled = false
    tags                 = local.tags
  }

  module "tf-mod-aws-eks-cluster" {
    source                = "git::https://github.com/Callumccr/tf-mod-aws-eks-cluster.git?ref=master
    namespace             = var.namespace
    stage                 = var.stage
    name                  = var.name
    attributes            = var.attributes
    tags                  = var.tags
    region                = var.region
    vpc_id                = module.vpc.vpc_id
    subnet_ids            = module.subnets.public_subnet_ids
    kubernetes_version    = var.kubernetes_version
    kubeconfig_path       = var.kubeconfig_path
    oidc_provider_enabled = var.oidc_provider_enabled

    workers_role_arns          = [module.eks_node_group.eks_node_group_role_arn]
    workers_security_group_ids = []
  }

  module "tf-mod-aws-eks-workers" {
    source                = "git::https://github.com/Callumccr/tf-mod-aws-eks-workers.git?ref=master
    namespace                 = var.namespace
    stage                     = var.stage
    name                      = var.name
    attributes                = var.attributes
    tags                      = var.tags
    vpc_id                    = module.vpc.vpc_id
    subnet_ids                = module.subnets.public_subnet_ids
    instance_types            = var.instance_types
    desired_size              = var.desired_size
    min_size                  = var.min_size
    max_size                  = var.max_size
    cluster_name              = module.eks_cluster.eks_cluster_id
    kubernetes_version        = var.kubernetes_version
  }
```


## Providers

| Name | Version |
|------|---------|
| aws | ~> 3.0 |

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
| aws\_assume\_role\_arn | ARN of the IAM role when optionally connecting to AWS via assumed role. Autoloaded from account.tfvars. | `string` | `""` | no |
| aws\_region | The AWS region (e.g. ap-southeast-2). Autoloaded from region.tfvars. | `string` | `""` | no |
| context | Default context to use for passing state between label invocations | <code><pre>object({<br>    namespace           = string<br>    environment         = string<br>    stage               = string<br>    name                = string<br>    enabled             = bool<br>    delimiter           = string<br>    attributes          = list(string)<br>    label_order         = list(string)<br>    tags                = map(string)<br>    additional_tag_map  = map(string)<br>    regex_replace_chars = string<br>  })<br></pre></code> | <code><pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": "",<br>  "enabled": true,<br>  "environment": "",<br>  "label_order": [],<br>  "name": "",<br>  "namespace": "",<br>  "regex_replace_chars": "",<br>  "stage": "",<br>  "tags": {}<br>}<br></pre></code> | no |
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




## Related Projects

You can find more [Terraform Modules](terraform_modules) by vising the link.

Additionally, check out these other related, and maintained projects.

- [%!s(<nil>)](%!s(<nil>)) - %!s(<nil>)



## References

For additional context, refer to some of these links. 

- [terraform-aws-modules/terraform-aws-eks](https://github.com/terraform-aws-modules/terraform-aws-eks) - A Terraform module to create an Elastic Kubernetes (EKS) cluster and associated worker instances on AWS.
- [cloudposse/terraform-aws-eks-node-group](https://github.com/cloudposse/terraform-aws-eks-node-group) - Terraform module to provision an EKS Node Group.



## Help

**Got a question?** We got answers. 

File a Github [issue](https://github.com/Callumccr/tf-mod-aws-eks-workers/issues), or message us on [Slack][slack]


### Contributors

|  [![Callum Robertson][callumccr_avatar]][callumccr_homepage]<br/>[Callum Robertson][callumccr_homepage] |
|---|


  [callumccr_homepage]: https://www.linkedin.com/in/callum-robertson-1a55b6110/

  [callumccr_avatar]: https://media-exp1.licdn.com/dms/image/C5603AQHb_3oZMZA5YA/profile-displayphoto-shrink_200_200/0?e=1588809600&v=beta&t=5QQQAlHrm1od5fQNZwdjOtbZWvsGcgNBqFRhZWgnPx4




---



---


[![README Footer][logo]][website]

  [logo]: https://wariva-github-assets.s3.eu-west-2.amazonaws.com/logo.png
  [website]: https://www.linkedin.com/company/52152765/admin/
  [github]: https://github.com/Callumccr
  [slack]: https://wariva.slack.com
  [linkedin]: https://www.linkedin.com/in/callum-robertson-1a55b6110/
  [terraform_modules]: https://github.com/Callumccr