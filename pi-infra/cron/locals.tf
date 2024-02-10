locals {
	safe_command = replace(var.command, "\"", "\\\"")
}
