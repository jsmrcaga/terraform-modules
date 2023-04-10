variable aws {
	type = object({
		shared_credentials_file = string
		region = optional(string, "eu-west-3")
	})
}

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

variable lambda_timeout {
	type = number
	# 30 seconds default, to match APIGateway
	default = 30
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

variable custom_domain {
	type = string
	default = null
}

variable deploy_empty {
	type = bool
	default = true
	description = "Creates an empty zip file to deploy, since AWS expects a file"
}
