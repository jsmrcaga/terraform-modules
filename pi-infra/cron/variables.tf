variable username {
  type = string
}

variable private_key {
  type = string
}

variable host {
  type = string
}

variable crons {
  type = list(object({
    cron_schedule = string
    command = string
  }))
}
