module "label" {
  source             = "git::https://github.com/Callumccr/tf-mod-label.git?ref=master"
  context            = var.context
  attributes         = ["eks", "workers"]
  delimiter          = "-"
  additional_tag_map = {} /* Additional attributes (e.g. 1) */
  label_order        = ["namespace", "environment", "name", "attributes"]
}

module "security_group_label" {
  source             = "git::https://github.com/Callumccr/tf-mod-label.git?ref=master"
  context            = module.label.context
  attributes         = ["sg"]
  additional_tag_map = {} /* Additional attributes (e.g. 1) */
  label_order        = ["namespace", "environment", "name", "attributes"]
}

module "policy_label" {
  source             = "git::https://github.com/Callumccr/tf-mod-label.git?ref=master"
  context            = module.label.context
  attributes         = ["policy"]
  additional_tag_map = {} /* Additional attributes (e.g. 1) */
  label_order        = ["namespace", "environment", "name", "attributes"]
}

module "role_label" {
  source             = "git::https://github.com/Callumccr/tf-mod-label.git?ref=master"
  context            = module.label.context
  attributes         = ["role"]
  additional_tag_map = {} /* Additional attributes (e.g. 1) */
  label_order        = ["namespace", "environment", "name", "attributes"]
}

module "nodegroup_label" {
  source             = "git::https://github.com/Callumccr/tf-mod-label.git?ref=master"
  context            = module.label.context
  attributes         = ["nodegroup"]
  additional_tag_map = {} /* Additional attributes (e.g. 1) */
  label_order        = ["namespace", "environment", "name", "attributes"]
}

