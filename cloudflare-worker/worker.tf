resource cloudflare_worker_script "worker_script" {
  name = var.script.name
  content = var.script.content

  dynamic "kv_namespace_binding" {
    # Create a binding for every kv namespace
    for_each = cloudflare_workers_kv_namespace.kv_namespaces
    iterator = "each"

    content {
      name = each.key
      namespace_id = each.value
    }
  }

  dynamic "secret_text_binding" {
    for_each = var.script.secrets
    iterator = "each"

    content {
      name = each.key
      text = each.value
    }
  }
}

resource cloudflare_workers_kv_namespace "kv_namespaces" {
  for_each = var.kv_namespaces
  title = each.value
}

resource cloudflare_worker_route "worker_route" {
  for_each = var.routes

  # Use every route zone id, or the default zone id
  zone_id = lookup(each.value, "zone_id", var.cloudflare.default_zone_id)
  pattern = each.value.pattern

  script_name = cloudflare_worker_script.worker_script.name
}


# DNS record
resource cloudflare_record "cloudflare_dns_record" {
  for_each = var.dns_records

  # Use every route zone id, or the default zone id
  zone_id = lookup(each.value, "zone_id", var.cloudflare.default_zone_id)

  name = each.value.name
  type = each.value.type
  # was "@" but cloudflare translates to top level domain
  value = each.value.value

  proxied = lookup(each.value, "proxied", true)
}
