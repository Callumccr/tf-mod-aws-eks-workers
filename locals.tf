locals {
  tags = merge(
    var.tags,
    {
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    },
    {
      "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
    },
    {
      "k8s.io/cluster-autoscaler/enabled" = "${var.enable_cluster_autoscaler}"
    }
  )

  workers_role_arn  = var.use_existing_aws_iam_instance_profile ? join("", data.aws_iam_instance_profile.default.*.role_arn) : join("", aws_iam_role.default.*.arn)
  workers_role_name = var.use_existing_aws_iam_instance_profile ? join("", data.aws_iam_instance_profile.default.*.role_name) : join("", aws_iam_role.default.*.name)

  remote_access = [
    {
      ec2_ssh_key = var.ec2_ssh_key
      source_security_group_ids = compact(
        concat(
          [
            var.use_existing_security_group == false ? join("", aws_security_group.default.*.id) : var.workers_security_group_id
          ],
          var.additional_security_group_ids
        )
      )
    }
  ]
}
