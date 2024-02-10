locals {
  # We need to build maps so that the for_each can work
	cron_map = {
    for c in var.crons:
    "${c.cron_schedule} ${c.command}" => c
  }

  docker_compose_map = {
    for d in var.docker_compose_files:
    d.file_path => d
  }
}
