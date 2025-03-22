resource kubernetes_secret_v1 sa_token {
  count = var.create_secret ? 1 : 0
  // Since we need to create the file with the result
  wait_for_service_account_token = true

  metadata {
    name = coalesce(var.secret_name, "${var.service_account}-token")

    annotations = {
      "kubernetes.io/service-account.name" = var.service_account
    }
  }

  type = "kubernetes.io/service-account-token"
}

resource local_file "kubeconfig" {
	content = local.kubeconfig
  filename = coalesce(var.filename, "${path.module}/sa-kubeconfig.yml")
}
