resource kubernetes_secret_v1 sa_token {
  wait_for_service_account_token = true

  metadata {
    name = "${local.sa_name}-token"
    namespace = var.namespace

    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account_v1.deployer_sa.metadata[0].name
    }
  }

  type = "kubernetes.io/service-account-token"
}
