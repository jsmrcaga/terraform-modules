locals {
	env_vars_resource_name = "${var.project_name}-env-vars"
  secrets_resource_name = "${var.project_name}-secret-env-vars"
	service_port = coalesce(var.service.port, var.deployment.port)
}
