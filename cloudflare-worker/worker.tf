resource cloudflare_worker_script "worker_script" {
  name = var.script.name
  content = var.script.content

  account_id = coalesce(var.script.account_id, var.cloudflare.default_account_id)

  lifecycle {
    ignore_changes = [
      content
    ]
  }

  dynamic "kv_namespace_binding" {
    # Create a binding for every kv namespace
    # for_each = cloudflare_workers_kv_namespace.kv_namespaces
    for_each = module.kv
    iterator = each

    content {
      name = each.value.kv_binding.binding
      namespace_id = each.value.kv_binding.kv_id
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

  dynamic "service_binding" {
    for_each = var.script.service_bindings
    iterator = each

    content {
      name = each.value.name
      service = each.value.service
      environment = each.value.environment
    }
  }
}

module kv {
  source = "./kv"

  count = length(local.kv_namespaces)

  title = local.kv_namespaces[count.index].title
  account_id = local.kv_namespaces[count.index].account_id
  binding = local.kv_namespaces[count.index].binding

  providers = {
    cloudflare = cloudflare
  }
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
