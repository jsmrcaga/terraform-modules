variable cloudflare {
  type = object({
    default_zone_id = optional(string)  
  })
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
}

variable routes {
  type = set(object({
    zone_id = optional(string)
    pattern = string
  }))
}

variable dns_records {
  type = set(object({
    zone_id = optional(string)
    name = string
    type = string
    value = string
    proxied = optional(bool)
  }))
}
