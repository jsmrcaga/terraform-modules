variable title {
  type = string
}

variable account_id {
  type = string
}

variable binding {
  type = string
}

resource cloudflare_workers_kv_namespace "kv_namespace" {
  title = var.title
  account_id = var.account_id
}

output "kv_binding" {
  value = {
    kv_id = cloudflare_workers_kv_namespace.kv_namespace.id
    binding = var.binding
  }
}
