output "api_gateway_api" {
  value = aws_apigatewayv2_api.api
}

output "api_gateway_api_integration" {
  value = aws_apigatewayv2_integration.api_integration
}

output "domain_validation_records" {
  value = module.custom_domain[0].validation_records
}

output "api_gateway_domain" {
  value = module.custom_domain[0].api_gateway_domain
}
