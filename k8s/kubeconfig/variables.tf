variable cluster_name {
  type = string
}

variable server {
  type = string
}

variable service_account {
  type = string
}

variable create_secret {
  type = bool
  default = true
}

variable secret_name {
  type = string
}

variable secret {
  type = object({
    "ca.crt" = string
    "token" = string  
  })

  default = null

  validation {
    condition = var.create_secret == false ? can(var.secret) : true
    message = "secret is mandatory if create_secret is false"
  }
}

