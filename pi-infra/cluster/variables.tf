variable default_auth {
  type = object({
    username = string
    private_key = string  
  })
  default = null
}

variable pis {
  type = list(object({
    host = string
    username = optional(string, null)
    private_key = optional(string, null)

    env_vars = optional(map(string), {})
    crons = optional(list(object({
      cron_schedule = string
      command = string
    })), [])
  }))
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

variable docker_compose_files {
  type = list(object({
    file_path = string
    destination_path = string
  }))
  default = []
}
