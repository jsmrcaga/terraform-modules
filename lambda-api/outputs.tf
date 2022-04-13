output "api_gateway_api" {
  value = aws_apigatewayv2_api.api
}

output "api_gateway_api_integration" {
  value = aws_apigatewayv2_integration.api_integration
}
