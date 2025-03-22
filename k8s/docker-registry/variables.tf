variable registry {
  type = string
  default = "https://index.docker.io/v1/"
  description = "By default: https://index.docker.io/v1/"
}

variable username {
  type = string
}

variable password {
  type = string
  sensitive = true
  description = "Usually password is a token (for ghcr for example)"
}

variable namespace {
  type = string
  default = "default"
}

variable name {
  type = string
  default = "docker-registry"
}
