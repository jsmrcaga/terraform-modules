resource kubernetes_service_account_v1 deployer_sa {
  metadata {
    name = local.sa_name
    namespace = var.namespace
  }
}
