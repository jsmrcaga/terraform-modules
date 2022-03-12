locals {
  # Will replace `zone_id` on every item of the dns record list
  dns_records = defaults(var.dns_records, {
    zone_id = var.cloudflare.default_zone_id  
    proxied = true
  })

  # Will replace `zone_id` on every item of the route list
  routes = defaults(var.routes, {
    zone_id = var.cloudflare.default_zone_id
  })
}
