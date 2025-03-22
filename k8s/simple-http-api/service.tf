resource kubernetes_service_v1 service {
  metadata {
    name = var.project_name
    namespace = module.namespace.name
  }

  spec {
    selector = {
      app = var.project_name
    }

    # @see: https://docs.k3s.io/networking#service-load-balancer
    type = "LoadBalancer"

    port {
      name = "main"
      port = local.service_port // the port of the service _within the cluster_
      target_port = var.deployment.port // 3000 the "container port"
    }
  }
}

resource kubernetes_ingress_v1 ingress {
  metadata {
    name = var.project_name
    namespace = module.namespace.name

    annotations = var.ingress.annotations
  }

  spec {
    rule {
      host = var.domain_name

      http {
        path {
          path = "/"
          path_type = "Prefix"

          backend {
            service {
              name = var.project_name
              port {
                number = local.service_port
              }
            }
          }
        }
      }
    }
  }
}
