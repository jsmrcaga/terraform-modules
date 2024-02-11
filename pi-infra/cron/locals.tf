locals {
	safe_commands = [for c in var.crons: {
		safe_command = replace(c.command, "\"", "\\\""),
		schedule = c.cron_schedule
	}]

	remove_commands = join("\n", [
		for c in local.safe_commands:
		"remove_crontab_schedule \"${c.safe_command}\""
	])

	echo_schedules = join("\n", [
		for c in local.safe_commands:
		"insert_schedule \"${c.schedule}\" \"${c.safe_command}\""
	])

	script = <<-EOT
    # Written and explained by ChatGTP 3.5

    remove_crontab_schedule() {
      local command="$1"

      if crontab -l | grep -qF "$command"; then
        crontab -l | sed "/$command/d" | cat | crontab -
      fi
    }

    insert_schedule () {
      local schedule="$1"
      local command="$2"
      (crontab -l 2>/dev/null; echo "$schedule $command") | crontab -
    }

    # Remove crontabs 1 per 1
    ${local.remove_commands}

    # Insert all crontabs in 1 go
    ${local.echo_schedules}
	EOT
}
