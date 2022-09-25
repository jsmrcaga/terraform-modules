variable aws {
  type = object({
    shared_credentials_file = string
    region = optional(string)
  })
}

variable task_definition {
  type = object({
    family = string
    cpu = optional(string)
    memory = optional(number)

    network_mode = optional(string)

    volumes = optional(map(string))
    requires_compatibilities = list(string)

    logs_prefix = optional(string)
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
    image_tag_mutability = optional(string)
    image_name = string
  })
}

variable service {
  type = object({
    name = string
    desired_count = optional(number)
    health_check_grace_period_seconds = optional(number)
    launch_type = optional(string)
    platform_version = optional(string)

    deployment_maximum_percent = optional(number)
    deployment_minimum_healthy_percent = optional(number)
  })
}

variable use_networking {
  type = bool
  default = false
}
