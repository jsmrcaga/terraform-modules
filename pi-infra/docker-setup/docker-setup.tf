module docker_compose_files {
	for_each = local.docker_compose_map
  source = "../ssh-scp"

  username = var.ssh.username
  private_key = var.ssh.private_key
  host = var.ssh.host

  file_path = each.value.file_path
  destination_path = each.value.destination_path
}

module env_vars {
  for_each = var.env_vars
  source = "../env-var"

  username = var.ssh.username
  private_key = var.ssh.private_key
  host = var.ssh.host

  key = each.key
  value = each.value
}

# We need to combine all crons into a single array
# Since there is a race condition and only 1 cron ends up being written
module crons {
  source = "../cron"

  username = var.ssh.username
  private_key = var.ssh.private_key
  host = var.ssh.host

  crons = var.crons
}
