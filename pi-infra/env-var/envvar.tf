resource terraform_data "remote-env-vars" {
  connection {
    type = "ssh"
    user = var.username
    private_key = var.private_key
    host = var.host
  }

  provisioner "remote-exec" {
    inline = [
      <<-EOT
        set_env_var() {
          if cat ~/.bashrc | grep -F "${var.key}"; then
            sed -i.bak 's/^${var.key}=.*/${var.key}=\"${var.value}\"/' ~/.bashrc
          else
            echo "${var.key}=\"${var.value}\"" >> ~/.bashrc
          fi
        }

        set_env_var > ~/.env-logs
      EOT
    ]
  }
}
