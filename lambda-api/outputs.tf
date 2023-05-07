output "api_gateway_api" {
  value = aws_apigatewayv2_api.api
}

output "api_gateway_api_integration" {
  value = aws_apigatewayv2_integration.api_integration
}

output "domain_validation_records" {
  value = length(module.custom_domain) > 0 ? module.custom_domain[0].validation_records : null
}

output "api_gateway_domain" {
  value = length(module.custom_domain) > 0 ? module.custom_domain[0].api_gateway_domain : null
}
