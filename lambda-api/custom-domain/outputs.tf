output "certificate" {
  value = aws_acm_certificate.cert
}

output "validation_records" {
  value = aws_acm_certificate.cert.domain_validation_options
}

output "domain_validation" {
  value = aws_acm_certificate_validation.cert_validation
}

output "api_gateway_domain" {
  value = aws_apigatewayv2_domain_name.api_domain
}
