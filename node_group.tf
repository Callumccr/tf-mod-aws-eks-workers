resource "aws_eks_node_group" "workers" {
  count           = var.enabled ? 1 : 0
  node_group_name = module.nodegroup_label.id
  cluster_name    = var.cluster_name
  node_role_arn   = join("", aws_iam_role.default.*.arn)
  subnet_ids      = var.subnet_ids
  ami_type        = var.ami_type
  disk_size       = var.disk_size
  instance_types  = var.instance_types
  labels          = var.kubernetes_labels
  release_version = var.ami_release_version
  version         = var.kubernetes_version

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  dynamic "remote_access" {
    for_each = [for r in local.remote_access : {
      ec2_ssh_key               = lookup(local.remote_access[0], "ec2_ssh_key")
      source_security_group_ids = lookup(local.remote_access[0], "source_security_group_ids")
      }
    ]
    content {
      ec2_ssh_key               = remote_access.value.ec2_ssh_key
      source_security_group_ids = remote_access.value.source_security_group_ids
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy,
    aws_iam_role_policy_attachment.amazon_eks_worker_node_autoscaler_policy,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only
  ]

  tags = module.nodegroup_label.tags

}
