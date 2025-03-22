variable project_name {
  type = string
}

variable domain_name {
  type = string
}

variable service {
  type = object({
    port = optional(number)
  })

  default = {}
}

variable docker_registry {
  type = object({
    username = string
    password = string
  })

  sensitive = true
}

variable ingress {
  type = object({
    annotations = optional(map(string), {
      "ingress.kubernetes.io/ssl-redirect" = "false"
    })
  })

  default = {}
}

variable deployment {
  type = object({
    environment = map(string)
    secrets = optional(map(string), {})

    node_name = optional(string)

    rolling_update_max_surge = optional(number)

    replicas = optional(number, 2)

    initial_image = optional(string)

    port = number

    volumes = optional(list(object({
      name = string
      host_path = string
      mount_path = string  
    })), [])
  })
}
