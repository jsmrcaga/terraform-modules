output kubeconfig {
  sensitive = true
  description = "The resulting kubectl config file"

  value = yamlencode({
    apiVersion = "v1"
    kind = "Config"
    preferences = {}
    current-context = local.output_context_name

    clusters = [{
      name = var.cluster_name
      cluster = {
        certificate-authority-data = var.ca_data
        server = var.k8s_server_address
      }
    }]

    contexts = [{
      name = local.output_context_name
      context = {
        user = kubernetes_service_account_v1.deployer_sa.metadata[0].name
        cluster = var.cluster_name
      }
    }]

    users = [{
      name = kubernetes_service_account_v1.deployer_sa.metadata[0].name
      user = {
        token = kubernetes_secret_v1.sa_token.data["token"]
      }
    }]
  })
}
