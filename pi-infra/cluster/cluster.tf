module pi_cluster {
  source = "../docker-setup"
  for_each = local.pi_map

  ssh = {
    username = coalesce(each.value.username, lookup(var.default_auth, "username"))
    private_key = coalesce(each.value.private_key, lookup(var.default_auth, "private_key"))
    host = each.value.host
  }

  env_vars = merge(var.env_vars, coalesce(each.value.env_vars, {}))
  crons = concat(var.crons, each.value.crons)
  docker_compose_files = var.docker_compose_files
}
