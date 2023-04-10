variable aws {
  type = object({
    shared_credentials_file = string
    region = optional(string, "eu-west-3")
  })
}

variable task_definition {
  type = object({
    family = string
    cpu = optional(string, "0.5")
    memory = optional(number, 1024)

    network_mode = optional(string, "bridge")

    volumes = optional(map(string), {})
    requires_compatibilities = list(string)

    logs_prefix = optional(string, "")
    definition = any
  })
}

variable cluster {
  type = object({
    name = string  
  })
}

variable ecr {
  type = object({
    name = string
    image_tag_mutability = optional(string, "IMMUTABLE")
    image_name = string
  })
}

variable service {
  type = object({
    name = string
    launch_type = optional(string, "FARGATE")
    platform_version = optional(string, "LATEST")

    desired_count = optional(number, 1)
    health_check_grace_period_seconds = optional(number)

    deployment_maximum_percent = optional(number, 200)
    deployment_minimum_healthy_percent = optional(number, 50)
  })
}

variable use_networking {
  type = bool
  default = false
}
