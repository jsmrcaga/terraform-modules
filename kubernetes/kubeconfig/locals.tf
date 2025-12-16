locals {
  role_name = coalesce(var.role_name, "${var.namespace}-deployer-role")
  role_binding_name = "${local.role_name}-binding"
  sa_name = coalesce(var.service_account_name, "${var.namespace}-deployer-sa")

  output_context_name = "${var.namespace}-deployer-context"
}
