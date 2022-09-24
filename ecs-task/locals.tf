locals {
  aws = defaults(var.aws, {
    region = "eu-west-3"  
  })

  # For some reason aws uses power 2 notation for cpu
  cpu_values = {
    "0.25" = 256
    "0.5" = 512
    "1" = 1024
    "2" = 2048
    "4" = 4096
    "8" = 8192
    "16" = 16384
  }

  ecr = defaults(var.ecr, {
    image_tag_mutability = "IMMUTABLE"  
  })

  service = defaults(var.service, {
    desired_count = 1
    launch_type = "FARGATE"
    platform_version = "LATEST"

    deployment_maximum_percent = 200
    deployment_minimum_healthy_percent = 50
  })

  task_definition = defaults(var.task_definition, {
    cpu = "0.5"
    memory = 1024
    network_mode = "bridge"

    volumes = ""
  })

  default_task_definition = {
    # see:
    # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#standard_container_definition_params

    memory = 256
    cpu = 256 // the whole thing
    memoryReservation = null

    entryPoint = ""
    command = ""
    workingDirectory = ""

    essential = true

    privileged = false

    user = ""
    ulimits = null
    # ulimits = [{
    #   name = ""
    #   hardLimit = ""
    #   softLimit = ""
    # }]

    dependsOn = null
    # dependsOn = [{
    #   containerName = ""
    #   condition = ""
    # }]

    readonlyFilesystem = false

    environmentFiles = null
    # environmentFiles = [{
    #   type = "s3"
    #   value = "arn"
    # }]

    environment = ""
    # environment = [{
    #   name = "plep"
    #   value = "plop"
    # }]

    secrets = null
    # secrets = [{
    #   name = "plep"
    #   valueFrom = "asm_arn"
    # }]

    portMappings = null
    # portMappings = [{
    #   containerPort
    #   hostPort
    #   protocol = "tcp"
    # }]

    healthCheck = {
      command = tolist(["CMD", "exit 0"])
      interval = 30 # seconds
      timeout = 2 # seconds, time to wait for the command to finish
      retries = 3
      startPeriod = 5 # seconds, startup time before health checks are considered unhealthy
    }

    disableNetworking = false

    # Link between containers
    links = ""
    # links = ["name:alias"]

    hostname = ""
    dnsServers = null
    # dnsServers = ["server1", "server2"]
    dnsSearchDomains = null
    # dnsServers = ["domain1", "domain2"]

    extraHosts = null
    # extraHosts = [{
    #   hostname = "mywebsite"
    #   ipAddress = "1.1.1.1"
    # }]

    mountPoints = null
    # mountPoints = [{
    #   sourceVolume = ""
    #   containerPath = ""
    #   readOnly = false
    # }]

    volumesFrom = null
    # volumesFrom = [{
    #   sourceContainer = ""
    #   readOnly = false
    # }]
  }

}
