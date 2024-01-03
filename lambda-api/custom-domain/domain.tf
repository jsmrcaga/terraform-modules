resource "aws_acm_certificate" "cert" {
    domain_name = var.domain
    validation_method = "DNS"

    tags = {}

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_acm_certificate_validation" "cert_validation" {
    certificate_arn = aws_acm_certificate.cert.arn
    validation_record_fqdns = aws_acm_certificate.cert.domain_validation_options.*.resource_record_name
}

resource "aws_apigatewayv2_domain_name" "api_domain" {
    domain_name = var.domain

    domain_name_configuration {
        endpoint_type = "REGIONAL"
        certificate_arn = aws_acm_certificate.cert.arn
        security_policy = "TLS_1_2"
    }
}

resource "aws_apigatewayv2_api_mapping" "api_mapping" {
    api_id = var.api_id
    stage = var.stage_id
    domain_name = aws_apigatewayv2_domain_name.api_domain.domain_name
}
