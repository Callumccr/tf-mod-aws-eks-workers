resource "aws_iam_policy" "amazon_eks_worker_node_autoscaler_policy" {
  count  = (var.enabled && var.enable_cluster_autoscaler) ? 1 : 0
  name   = "${module.label.id}-autoscaler"
  path   = "/"
  policy = join("", data.aws_iam_policy_document.amazon_eks_worker_node_autoscaler_policy.*.json)
}

resource "aws_iam_role" "default" {
  count              = var.enabled ? 1 : 0
  name               = module.role_label.id
  assume_role_policy = join("", data.aws_iam_policy_document.assume_role.*.json)
  tags               = module.role_label.tags
}

resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy" {
  count      = var.enabled ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = join("", aws_iam_role.default.*.name)
}

resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_autoscaler_policy" {
  count      = (var.enabled && var.enable_cluster_autoscaler) ? 1 : 0
  policy_arn = join("", aws_iam_policy.amazon_eks_worker_node_autoscaler_policy.*.arn)
  role       = join("", aws_iam_role.default.*.name)
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy" {
  count      = var.enabled ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = join("", aws_iam_role.default.*.name)
}

resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_read_only" {
  count      = var.enabled ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = join("", aws_iam_role.default.*.name)
}

resource "aws_iam_role_policy_attachment" "existing_policies_for_eks_workers_role" {
  count      = var.enabled ? var.existing_workers_role_policy_arns_count : 0
  policy_arn = var.existing_workers_role_policy_arns[count.index]
  role       = join("", aws_iam_role.default.*.name)
}

resource "aws_security_group" "default" {
  count       = var.enabled && var.use_existing_security_group == false ? 1 : 0
  name        = module.security_group_label.id
  description = "Security Group for EKS worker nodes"
  vpc_id      = var.vpc_id
  tags        = module.security_group_label.tags
}

resource "aws_security_group_rule" "egress" {
  count             = var.enabled && var.use_existing_security_group == false ? 1 : 0
  description       = "Allow all egress traffic"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = join("", aws_security_group.default.*.id)
  type              = "egress"
}

resource "aws_security_group_rule" "ingress_self" {
  count                    = var.enabled && var.use_existing_security_group == false ? 1 : 0
  description              = "Allow nodes to communicate with each other"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  security_group_id        = join("", aws_security_group.default.*.id)
  source_security_group_id = join("", aws_security_group.default.*.id)
  type                     = "ingress"
}

resource "aws_security_group_rule" "ingress_cluster" {
  count                    = var.enabled && var.use_existing_security_group == false ? 1 : 0
  description              = "Allow worker kubelets and pods to receive communication from the cluster control plane"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  security_group_id        = join("", aws_security_group.default.*.id)
  source_security_group_id = var.cluster_security_group_id
  type                     = "ingress"
}

resource "aws_security_group_rule" "ingress_security_groups" {
  count                    = var.enabled && var.use_existing_security_group == false ? length(var.additional_security_group_ids) : 0
  description              = "Allow inbound traffic from existing Security Groups"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  source_security_group_id = var.additional_security_group_ids[count.index]
  security_group_id        = join("", aws_security_group.default.*.id)
  type                     = "ingress"
}

resource "aws_security_group_rule" "ingress_cidr_blocks" {
  count             = var.enabled && length(var.allowed_cidrs) > 0 && var.use_existing_security_group == false ? 1 : 0
  description       = "Allow inbound traffic from CIDR blocks"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = var.allowed_cidrs
  security_group_id = join("", aws_security_group.default.*.id)
  type              = "ingress"
}