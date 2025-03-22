resource kubernetes_deployment_v1 deployment {
  lifecycle {
    # Ignore image to allow TF changes as well as CI/CD deployments
    ignore_changes = [
      spec[0].template[0].spec[0].container[0].image
    ]
  }

  metadata {
    name = var.project_name
    namespace = module.namespace.name

    labels = {
      app = var.project_name
    }
  }

  spec {
    replicas = var.deployment.replicas

    selector {
      match_labels = {
        app = var.project_name
      }
    }

    strategy {
      type = "RollingUpdate"
      rolling_update {
        max_surge = coalesce(var.deployment.rolling_update_max_surge, var.deployment.replicas)
      }
    }

    template {
      metadata {
        labels = {
          app = var.project_name
        }
      }

      spec {
        node_name = var.deployment.node_name

        image_pull_secrets {
          name = module.docker_registry.name
        }

        dynamic volume {
          for_each = var.deployment.volumes

          content {
            name = each.value.name
            host_path {
              path = each.value.host_path
              type = "File"
            }
          }
        }

        container {
          image = var.deployment.initial_image
          name = var.project_name

          port {
            container_port = var.deployment.port
          }

          dynamic volume_mount {
            for_each = var.deployment.volumes

            content {
              name = each.value.name
              mount_path = each.value.mount_path
            }

          }

          # ENVIRONMENT
          dynamic env {
            for_each = var.deployment.environment
            iterator = env_var

            content {
              name = env_var.key
              value_from {
                config_map_key_ref {
                  name = local.env_vars_resource_name
                  key = env_var.key
                }
              }
            }
          }

          dynamic env {
            for_each = var.deployment.secrets
            iterator = secret_var

            content {
              name = secret_var.key
              value_from {
                secret_key_ref {
                  name = local.secrets_resource_name
                  key = secret_var.key
                }
              }
            }
          }
        }

      }
    }
  }
}
