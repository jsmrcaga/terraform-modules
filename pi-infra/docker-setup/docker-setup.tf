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

module crons {
  for_each = local.cron_map
  source = "../cron"

  username = var.ssh.username
  private_key = var.ssh.private_key
  host = var.ssh.host

  command = each.value.command
  cron_schedule = each.value.cron_schedule
}
