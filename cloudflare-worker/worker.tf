resource cloudflare_worker_script "worker_script" {
  name = var.script.name
  content = var.script.content

  dynamic "kv_namespace_binding" {
    # Create a binding for every kv namespace
    for_each = cloudflare_workers_kv_namespace.kv_namespaces
    iterator = each

    content {
      name = each.value.title
      namespace_id = each.value.id
    }
  }

  dynamic "secret_text_binding" {
    for_each = var.script.secrets
    iterator = each

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
  # NOTE: note the usage of local to get the defaulted values
  count = length(local.routes)

  # Use every route zone id, or the default zone id
  zone_id = local.routes[count.index].zone_id
  pattern = local.routes[count.index].pattern

  script_name = cloudflare_worker_script.worker_script.name
}


# DNS record
resource cloudflare_record "cloudflare_dns_record" {
  # NOTE: note the usage of local to get the defaulted values
  count = length(local.dns_records)

  # Use every route zone id, or the default zone id
  zone_id = local.dns_records[count.index].zone_id

  name = local.dns_records[count.index].name
  type = local.dns_records[count.index].type
  # was "@" but cloudflare translates to top level domain
  value = local.dns_records[count.index].value

  proxied = local.dns_records[count.index].proxied
}
