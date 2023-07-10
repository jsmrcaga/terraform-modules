variable cloudflare {
  type = object({
    api_token = string
    default_zone_id = optional(string, null)
    default_account_id = optional(string, null)
  })
}

variable script {
	type = object({
    name = string
    content = string
    account_id = optional(string)
    secrets = map(string)

    service_bindings = list(object({
      name = string
      service = string
      environment = optional(string)  
    }))
  })
}

variable kv_namespaces {
  type = list(object({
    title = string
    binding = string
    account_id = optional(string)  
  }))
  default = []
}

variable routes {
  type = list(object({
    zone_id = optional(string)
    pattern = string
  }))

  default = []
}

variable dns_records {
  type = list(object({
    name = string
    type = string
    value = string
    proxied = optional(bool, true)
    zone_id = optional(string)
  }))

  default = []
}
