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

    execution_role_arn = optional(string)
    network_mode = optional(string)

    volumes = optional(map(string))
    requires_compatibilities = list(string)

    definition = optional(object({
      name = string

      image = optional(string)
      memory = optional(number)
      cpu = optional(number)
      memoryReservation = optional(number)

      entryPoint = optional(list(string))
      command = optional(list(string))
      workingDirectory = optional(string)

      essential = optional(bool)

      privileged = optional(bool)

      user = optional(string)
      ulimits = optional(list(object({
        name = string
        hardLimit = number
        softLimit = number  
      })))
      
      dependsOn = optional(list(object({
        containerName = string
        condition = string  
      })))

      readonlyFilesystem = optional(bool)

      environmentFiles = optional(list(object({
        type = string
        value = string  
      })))

      environment = optional(list(object({
        name = string
        value = string  
      })))

      secrets = optional(list(object({
        name = string
        valueFrom = string  
      })))

      portMappings = optional(list(object({
        containerPort = number
        hostPort = number
        protocol = string  
      })))

      healthCheck = optional(object({
        command = list(string)
        interval = number
        timeout = number
        retries = number
        startPeriod = number
      }))

      disableNetworking = optional(bool)

      links = optional(list(string))

      hostname = optional(string)
      dnsServers = optional(list(string))
      dnsSearchDomains = optional(list(string))

      extraHosts = optional(list(object({
        hostname = string
        ipAddress = string
      })))

      mountPoints = optional(list(object({
        sourceVolume = string
        containerPath = string
        readOnly = bool
      })))

      volumesFrom = optional(list(object({
        sourceContainer = string
        readOnly = bool
      })))
    }))
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
