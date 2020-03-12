# -----------------------------------------------------------------------------
# Variables: Common AWS Provider - Autoloaded from Terragrunt
# -----------------------------------------------------------------------------

variable "aws_region" {
  description = "The AWS region (e.g. ap-southeast-2). Autoloaded from region.tfvars."
  type        = string
  default     = ""
}

variable "aws_account_id" {
  description = "The AWS account id of the provider being deployed to (e.g. 12345678). Autoloaded from account.tfvars"
  type        = string
  default     = ""
}

variable "aws_assume_role_arn" {
  description = "(Optional) - ARN of the IAM role when optionally connecting to AWS via assumed role. Autoloaded from account.tfvars."
  type        = string
  default     = ""
}

variable "aws_assume_role_session_name" {
  description = "(Optional) - The session name to use when making the AssumeRole call."
  type        = string
  default     = ""
}

variable "aws_assume_role_external_id" {
  description = "(Optional) - The external ID to use when making the AssumeRole call."
  type        = string
  default     = ""
}

# -----------------------------------------------------------------------------
# Variables: TF-MOD-AWS-EKS-WORKERS
# -----------------------------------------------------------------------------

variable "enabled" {
  type        = bool
  description = "(Optional) - Whether to create the resources. Set to `false` to prevent the module from creating any resources"
  default     = true
}

variable "enable_cluster_autoscaler" {
  type        = bool
  description = "(Optional) - Whether to enable node group to scale the Auto Scaling Group"
  default     = false
}

variable "cluster_name" {
  type        = string
  description = "(Required) - The name of the EKS cluster"
}

variable "ec2_ssh_key" {
  type        = string
  description = "(Optional) - SSH key name that should be used to access the worker nodes"
  default     = null
}

variable "desired_size" {
  type        = number
  description = "(Required) - Desired number of worker nodes"
}

variable "max_size" {
  type        = number
  description = "(Required) - Maximum number of worker nodes"
}

variable "min_size" {
  type        = number
  description = "(Required) - Minimum number of worker nodes"
}

variable "vpc_id" {
  type        = string
  description = "(Optional) - VPC ID for the EKS workers"
  default     = ""
}

variable "subnet_ids" {
  description = "(Required) - A list of subnet IDs to launch resources in"
  type        = list(string)
}

variable "existing_workers_role_policy_arns" {
  type        = list(string)
  default     = []
  description = "(Optional) - List of existing policy ARNs that will be attached to the workers default role on creation"
}

variable "existing_workers_role_policy_arns_count" {
  type        = number
  default     = 0
  description = "(Optional) - Count of existing policy ARNs that will be attached to the workers default role on creation. Needed to prevent Terraform error `count can't be computed`"
}

variable "ami_type" {
  type        = string
  description = "(Optional) - Type of Amazon Machine Image (AMI) associated with the EKS Node Group. Defaults to `AL2_x86_64`. Valid values: `AL2_x86_64`, `AL2_x86_64_GPU`. Terraform will only perform drift detection if a configuration value is provided"
  default     = "AL2_x86_64"
}

variable "disk_size" {
  type        = number
  description = "(Optional) - Disk size in GiB for worker nodes. Defaults to 20. Terraform will only perform drift detection if a configuration value is provided"
  default     = 20
}

variable "instance_types" {
  type        = list(string)
  description = "(Required) - Set of instance types associated with the EKS Node Group. Defaults to [\"t3.medium\"]. Terraform will only perform drift detection if a configuration value is provided"
}

variable "kubernetes_labels" {
  type        = map(string)
  description = "(Optional) - Key-value mapping of Kubernetes labels. Only labels that are applied with the EKS API are managed by this argument. Other Kubernetes labels applied to the EKS Node Group will not be managed"
  default     = {}
}

variable "ami_release_version" {
  type        = string
  description = "(Optional) - AMI version of the EKS Node Group. Defaults to latest version for Kubernetes version"
  default     = null
}

variable "kubernetes_version" {
  type        = string
  description = "(Optional) - Kubernetes version. Defaults to EKS Cluster Kubernetes version. Terraform will only perform drift detection if a configuration value is provided"
  default     = null
}

variable "source_security_group_ids" {
  type        = list(string)
  default     = []
  description = "(Optional) - Set of EC2 Security Group IDs to allow SSH access (port 22) from on the worker nodes. If you specify `ec2_ssh_key`, but do not specify this configuration when you create an EKS Node Group, port 22 on the worker nodes is opened to the Internet (0.0.0.0/0)"
}

variable "use_existing_security_group" {
  type        = boolean
  default     = false
  description = "(Optional) - Whether to create a security group for the workers or use an existing"
}

variable "allowed_cidrs" {
  description = "(Optional) - List of CIDR blocks which can access the Amazon EKS workers"
  type        = list(string)
  default     = [""]
}

variable "additional_security_group_ids" {
  description = "(Optional) - Allow inbound traffic from existing Security Groups"
  type        = list(string)
  default     = []
}

# -----------------------------------------------------------------------------
# Variables: TF-MOD-LABEL
# -----------------------------------------------------------------------------

variable "namespace" {
  type        = string
  default     = ""
  description = "(Optional) - Namespace, which could be your abbreviated product team, e.g. 'rci', 'mi', 'hp', or 'core'"
}

variable "environment" {
  type        = string
  default     = ""
  description = "(Optional) - Environment, e.g. 'dev', 'qa', 'staging', 'prod'"
}

variable "name" {
  type        = string
  default     = ""
  description = "(Optional) - Solution name, e.g. 'vault', 'consul', 'keycloak', 'k8s', or 'baseline'"
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "(Optional) - Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`"
}

variable "attributes" {
  type        = list(string)
  default     = []
  description = "(Optional) - Additional attributes (e.g. `1`)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "(Optional) - Additional tags"
}
