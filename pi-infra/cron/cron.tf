resource terraform_data "remote-cron" {
  triggers_replace = [
    local.script
  ]

  connection {
    type = "ssh"
    user = var.username
    private_key = var.private_key
    host = var.host
  }

  provisioner "remote-exec" {
    inline = [
      local.script
    ]
  }
}
