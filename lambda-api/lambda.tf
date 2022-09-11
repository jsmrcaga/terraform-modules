# We do this to deploy an empty lambda
data archive_file "dummy_zip" {
    count = var.deploy_empty ? 1 : 0
    type = "zip"
    output_path = "${path.module}/dummy_lambda.zip"

    source {
        content = "empty"
        filename = "dummy.txt"
    }
}

resource aws_iam_role lambda_role {
    tags = {}
    name = "${var.function_name}_role"

    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Main lambda
resource aws_lambda_function "lambda_function" {
    function_name = var.function_name
    role  = aws_iam_role.lambda_role.arn

    handler = var.lambda_handler
    runtime = var.lambda_runtime
    filename = var.deploy_empty ? data.archive_file.dummy_zip[0].output_path : var.lambda_filename

    layers = []
    tags = {}

    environment {
        variables = var.lambda_env
    }
}


# API Gateway Routing
resource aws_apigatewayv2_api api {
    name = "${var.function_name}_api"
    protocol_type = "HTTP" // could be websocket
    tags = {}

    cors_configuration {
        allow_origins = ["*"]
        allow_headers = ["*"]
        allow_methods = ["*"]
        expose_headers = ["*"]
    }
}

resource aws_apigatewayv2_integration "api_integration" {
    api_id = aws_apigatewayv2_api.api.id
    integration_type = "AWS_PROXY"

    integration_method = "POST"
    integration_uri = aws_lambda_function.lambda_function.invoke_arn
    payload_format_version = "2.0"

    request_parameters = {}
    request_templates = {}
}

resource aws_apigatewayv2_route "route_default" {
    route_key = "$default"
    api_id = aws_apigatewayv2_api.api.id
    target = "integrations/${aws_apigatewayv2_integration.api_integration.id}"

    authorization_scopes = []
    request_models = {}
}

resource aws_apigatewayv2_route route_options {
    route_key = "OPTIONS /{proxy+}"
    api_id = aws_apigatewayv2_api.api.id
    target = "integrations/${aws_apigatewayv2_integration.api_integration.id}"

    authorization_scopes = []
    request_models = {}
}


# Logging for APIGateway
resource aws_cloudwatch_log_group "api_gateway_logs" {
    count = var.include_api_logs ? 1 : 0
    name = "${var.function_name}_APIGateway_Logs"
    tags = {}
}

resource aws_apigatewayv2_stage "default_stage" {
    api_id = aws_apigatewayv2_api.api.id
    name   = "$default"

    auto_deploy = true

    stage_variables = {}
    tags = {}

    dynamic access_log_settings {
        # Hack to add an optional block by paasing an empty array
        for_each = var.include_api_logs ? [1] : []
        content {
            # Index is set because we have a "count" on the resource
            destination_arn = aws_cloudwatch_log_group.api_gateway_logs[0].arn
            format = "{ \"requestId\":\"$context.requestId\", \"ip\": \"$context.identity.sourceIp\", \"requestTime\":\"$context.requestTime\", \"httpMethod\":\"$context.httpMethod\",\"routeKey\":\"$context.routeKey\", \"status\":\"$context.status\",\"protocol\":\"$context.protocol\", \"responseLength\":\"$context.responseLength\", \"integrationErrorMessage\": \"$context.integrationErrorMessage\" }"
        }
    }
}


# Permission for APIGateway
resource aws_lambda_permission "api_permission" {
    action = "lambda:InvokeFunction"
    function_name = var.function_name
    principal = "apigateway.amazonaws.com"
    source_arn = "${aws_apigatewayv2_api.api.execution_arn}/*"
}


# Logs
resource aws_iam_role_policy "lambda_role_logs_policy" {
    count = var.include_lambda_logs ? 1 : 0
    role   = aws_iam_role.lambda_role.id
    policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:*:*:*"
      ]
    }
  ]
}
POLICY
}
