module namespace {
  source = "../namespace"

  name = var.project_name
}

module docker_registry {
  source = "../docker-registry"

  username = var.docker_registry.username
  password = var.docker_registry.password

  namespace = module.namespace.name

  name = "github-container-registry"
  registry = "ghcr.io"
}
