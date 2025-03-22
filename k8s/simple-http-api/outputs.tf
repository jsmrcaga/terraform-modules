output namespace {
  value = module.namespace
}

output registry {
  value = module.docker_registry
}

output env_vars {
  value = kubernetes_config_map_v1.environment_variables
}

output secret_env_vars {
  value = kubernetes_secret_v1.environment_secrets
}

output deployment {
  value = kubernetes_deployment_v1.deployment
}

output service {
  value = kubernetes_service_v1.service
}

output ingress {
  value = kubernetes_ingress_v1.ingress
}
