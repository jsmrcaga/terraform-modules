locals {
  routes = var.routes == null ? [] : [ for route in var.routes: {
    zone_id = coalesce(route.zone_id, var.cloudflare.default_zone_id)
    pattern = route.pattern
  }]

  dns_records = var.dns_records == null ? [] : [ for record in var.dns_records: {
    name = record.name
    type = record.type
    value = record.value
    proxied = record.proxied
    zone_id = coalesce(record.zone_id, var.cloudflare.default_zone_id)
  }]

  kv_namespaces = var.kv_namespaces == null ? [] : [ for kv in var.kv_namespaces: {
    title = kv.title
    binding = kv.binding
    account_id = coalesce(kv.account_id, var.cloudflare.default_account_id)
  }]
}
