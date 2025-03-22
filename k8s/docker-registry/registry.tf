resource kubernetes_secret_v1 "docker_registry" {
  metadata {
    name = var.name
    namespace = var.namespace
  }

  # This type is necessary for Kubernetes to know what to do with it later
  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "${var.registry}" = {
          username = var.username
          password = var.password
          auth = base64encode("${var.username}:${var.password}")
        }
      }
    })
  }
}
