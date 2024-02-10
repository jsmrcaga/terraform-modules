resource terraform_data "remote-cron" {
  connection {
    type = "ssh"
    user = var.username
    private_key = var.private_key
    host = var.host
  }

  provisioner "remote-exec" {
    inline = [
      <<-EOT
        # Written and explained by ChatGTP 3.5

        set_crontab_schedule() {
          local schedule="$1"
          local command="$2"
          
          if crontab -l | grep -qF "$command"; then
            # Replace existing crontab entry
            crontab -l | sed "/$command/d" | { cat; echo "$schedule $command"; } | crontab -
          else
            # Add new crontab entry
            (crontab -l 2>/dev/null; echo "$schedule $command") | crontab -
          fi
        }

        set_crontab_schedule "${var.cron_schedule}" "${local.safe_command}" > ~/.cron-logs
      EOT
    ]
  }
}
