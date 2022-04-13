variable function_name {
	type = string
}

variable lambda_handler {
	type = string
}

variable lambda_runtime {
	type = string
}

variable lambda_filename {
	type = string
	default = null
}

variable lambda_env {
	type = map(any)
	default = {}
}

variable include_api_logs {
	type = bool
	default = true
}

variable include_lambda_logs {
	type = bool
	default = true
}
