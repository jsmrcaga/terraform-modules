output secret {
  value = kubernetes_secret_v1.docker_registry
}

output name {
  value = kubernetes_secret_v1.docker_registry.metadata[0].name
}
