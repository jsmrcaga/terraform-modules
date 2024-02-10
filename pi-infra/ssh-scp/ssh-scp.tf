resource terraform_data "ssh-scp" {
  connection {
    type = "ssh"
    user = var.username
    private_key = var.private_key
    host = var.host
  }

	provisioner "file" {
    source = var.file_path
    destination = var.destination_path
  }
}
