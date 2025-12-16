variable cluster_name {
  type = string
  sensitive = true
}

variable ca_data {
  type = string
  sensitive = true
}

variable k8s_server_address {
  type = string
  sensitive = true
}

variable namespace {
  type = string
}

variable role_name {
  type = string
  default = null
}

variable service_account_name {
  type = string
  default = null
}

variable resource_names {
  type = list(string)
  description = "Use this to restrict to specific deployments/sts from the namespace"
  default = []
}
