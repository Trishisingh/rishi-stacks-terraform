output "app_gateway_resource_group_name" {
  description = "Resource group of the application gateway"
  value       = azurerm_public_ip.app_gateway.resource_group_name
}

output "app_gateway_name" {
  description = "Name of the application gateway"
  value       = azurerm_public_ip.app_gateway.name
}

output "app_gateway_ip" {
  description = "Application Gateway public IP. Should be used with DNS provider at a top level. Can have multiple subs pointing to it - e.g. app.sub.domain.com, app-uat.sub.domain.com. App Gateway will perform SSL termination for all "
  value       = data.azurerm_public_ip.default.ip_address
}

output "app_gateway_ip_name" {
  description = "Application Gateway public IP name. Should be used with DNS provider at a top level. Can have multiple subs pointing to it - e.g. app.sub.domain.com, app-uat.sub.domain.com. App Gateway will perform SSL termination for all "
  value       = azurerm_public_ip.app_gateway.name
}

output "certificate_pem" {
  description = "PEM key of certificate, can be used internally"
  value       = var.create_valid_cert ? acme_certificate.default.0.certificate_pem : tls_self_signed_cert.self_cert.0.cert_pem
  sensitive   = true
}

output "issuer_pem" {
  description = "PEM key of certificate, can be used internally together certificate to create a full cert"
  value       = var.create_valid_cert ? acme_certificate.default.0.issuer_pem : ""
  sensitive   = true
}
