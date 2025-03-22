locals {
  context_name = "${var.service_account}@${var.cluster_name}"

  ca = var.create_secret ? kubernetes_secret_v1.sa_token.data["ca.crt"] : var.secret["ca.crt"]
  b64_token = var.create_secret ? kubernetes_secret_v1.sa_token.data["token"] : var.secret["token"]
  token = base64decode(b64_token)

  kubeconfig = yamlencode({
    apiVersion = "v1"
    kind = "Config"

    clusters = [{
      name = var.cluster_name
      cluster = {
        certificate-authority-data = local.ca
        server = var.server
      }  
    }]

    contexts = [{
      name = local.context_name
      context = {
        cluster = var.cluster_name
        namespace = var.namespace
        user = var.service_account
      }
    }]

    users = [{
      name = var.service_account
      user = {
        token = local.token
      }
    }]

    current-context = local.context_name
  })
}
