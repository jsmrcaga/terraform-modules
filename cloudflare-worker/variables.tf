variable cloudflare {
  type = object({
    default_zone_id = optional(string)
  })

  default = {}
}

variable script {
	type = object({
    name = string
    content = string
    secrets = map(string)
  })
}

variable kv_namespaces {
  type = set(string)
  default = []
}

variable routes {
  type = list(object({
    zone_id = optional(string)
    pattern = string
  }))
}

variable dns_records {
  type = list(object({
    name = string
    type = string
    value = string
    proxied = optional(bool)
    zone_id = optional(string)
  }))
}
