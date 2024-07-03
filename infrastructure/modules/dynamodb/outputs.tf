output "exchange_rate_table_arn" {
  value       = module.exchange_rates_table.dynamodb_table_arn
  description = "Exchange Rates table ARN"
}