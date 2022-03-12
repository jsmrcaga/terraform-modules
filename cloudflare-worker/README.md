# Cloudflare Worker

A simple Cloudflare worker script, allowing you to create KV namespaces and add any DNS records you would need

## Config
This module uses the following Cloudflare provider [`cloudflare/cloudflare`](https://registry.terraform.io/providers/cloudflare/cloudflare/3.10.1) v3.9.1

To configure it you will need to add a Terraform configuration file with the following
```terraform
terraform {
	required_providers {
		cloudflare = {
			source = "cloudflare/cloudflare"
			version = "~> 3.9.1"
		}
	}
}
```
As well as your authentication information
```terraform

provider "cloudflare" {
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_key
}
```
or
```terraform

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
```

More information [can be found here](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs#argument-reference)

## Resources

This module will create the following resources depending on the variables you pass to it:

- a single `cloudflare_worker_script`
- as many `cloudflare_workers_kv_namespace` as you specify
- the same quantity of bindings between the script and the KV-namespaces
- as many `cloudflare_worker_route` as you specify
- as many `cloudflare_record` as you specify

## Variables

This module expects the following "complete" configuration
```terraform
module my_worker {
  source = "git@github.com:jsmrcaga/terraform-modules.git//cloudflare-worker?ref=v0.0.1"

  cloudflare = {
    default_zone_id = var.cloudflare.zone_id
  }

  script = {
    name = "my worker"
    content = file("index.js")
    secrets = {
      MY_SUPER_SECRET = var.my_super_secret
    }
  }

  routes = [{
    pattern = "my.website.com/some/internal/route*"
  },{
    pattern = "my.other-website.com/some/internal/route*"
    zone_id = var.cloudflare.zone_2_id
  }]

  dns_records = [{
    name = "my"
    type = "CNAME"
    value = "website.com"
  }, {
    name = "my"
    type = "CNAME"
    value = "other-website.com"
    zone_id = var.cloudflare.zone_2_id,
    proxied = false
  }]
}
```

As you can see some configuration provides some defaults:

### `routes`
All routes are defined as
```terraform
{
	zone_id: <the zone id for the Worker route>
	pattern: <the pattern of the route>
}
```

* `zone_id` is optional. if not defined, `cloudflare.default_zone_id` will be used

### `dns_records`
DNS records allow you to add DNS records "on the fly" when specifying your worker. This can be useful 
if you'll be using a subdomain that has not been created yet.

As for routes, the `zone_id` argument will default to `cloudflare.default_zone_id`.
The `proxied` attribute will default to `true`
```terraform
{
	name = "subdomain" or any other value for the record
	value = "website.com" (@ is auto-translated by Cloudflare) or ay other value
	type = <record type>
	proxied = true | false
	zone_id = <the zone id for the Worker route>
}
```

* For the `value` property, if you enter `@`, Cloudflare will auto-translate to your domain name, creating a plan diff on your next Terraform run. TO prevent this you should enter the domain name directly
