resource kubernetes_config_map_v1 environment_variables {
  metadata {
    name = local.env_vars_resource_name
    namespace = module.namespace.name
  }

  data = var.deployment.environment
}

resource kubernetes_secret_v1 environment_secrets {
  metadata {
    name = local.secrets_resource_name
    namespace = module.namespace.name
  }

  data = var.deployment.secrets
}
