variable ssh {
  type = object({
    username = string
    private_key = string
    host = string
  })
}

variable docker_compose_files {
  type = list(object({
    file_path = string
    destination_path = string
  }))
  default = []
}

variable env_vars {
  type = map(string)
  default = {}
}

variable crons {
  type = list(object({
    cron_schedule = string
    command = string
  }))
  default = []
}
