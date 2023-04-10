locals {
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

  default_task_definition = {
    # see:
    # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#standard_container_definition_params

    memory = 256
    cpu = 256 // the whole thing

    essential = true

    privileged = false

    healthCheck = {
      command = tolist(["CMD", "exit 0"])
      interval = 30 # seconds
      timeout = 2 # seconds, time to wait for the command to finish
      retries = 3
      startPeriod = 5 # seconds, startup time before health checks are considered unhealthy
    }

    disableNetworking = false
  }

}
